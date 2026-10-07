#!/usr/bin/env bash
# Force the dev kitty (kitty --class devkitty) onto the "Desarrollo" desktop
# and keep it borderless (idempotent).
#
# The existing rule [1] matches wmclass=kitty exactly, so the dev kitty needs
# its own rule. This script finds that rule by its wmclass (or Description) and
# updates it in place; only if it is absent does it append a new rule id and
# bump [General] count/rules. The "Desarrollo" desktop UUID is read live from
# KWin over D-Bus — nothing is hardcoded.
#
# KWin 6 note: the forced-desktop rule keys are PLURAL — desktops (comma-
# separated virtual-desktop UUIDs) + desktopsrule. The singular desktop/
# desktoprule pair is the legacy numeric key and is ignored by Plasma 6
# (kwinrules.upd:use-virtual-desktop-ids); this script deletes it if present.
#
# Symlink trap: ~/.config/kwinrulesrc is a symlink into this repo and
# kwriteconfig6 writes via tmp+rename, so writing to the symlink path would
# REPLACE the link with a real file. All writes go to the real repo path and
# the script verifies afterwards that the symlink is still a symlink.
#
# Usage: bash kde/apply-dev-kitty.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KWINRULES="$HERE/kwinrulesrc"
LINK_PATH="$HOME/.config/kwinrulesrc"
RULE_DESC="kitty dev tmux -> Desarrollo"
RULE_WMCLASS="devkitty"
DESKTOP_NAME="Desarrollo"

echo "== Dev kitty: KWin rule -> '$DESKTOP_NAME' + borderless =="

for cmd in qdbus6 kwriteconfig6 kreadconfig6; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd not found (a live Plasma 6 session is required)" >&2
    exit 1
  fi
done

if [ ! -f "$KWINRULES" ]; then
  echo "ERROR: $KWINRULES not found" >&2
  exit 1
fi

# Emit "position<TAB>uuid<TAB>name" per desktop, in KWin order.
read_desktops() {
  qdbus6 --literal org.kde.KWin /VirtualDesktopManager \
    org.kde.KWin.VirtualDesktopManager.desktops \
    | grep -oP '\(uss\) \d+, "[^"]+", "[^"]+"' \
    | sed 's/(uss) \([0-9]\+\), "\([^"]*\)", "\([^"]*\)"/\1\t\2\t\3/'
}

# 1) Resolve the "Desarrollo" desktop UUID at runtime (never hardcoded)
DESKTOP_UUID=""
while IFS=$'\t' read -r _pos uuid name; do
  if [ "$name" = "$DESKTOP_NAME" ]; then
    DESKTOP_UUID="$uuid"
    break
  fi
done < <(read_desktops)

if [ -z "$DESKTOP_UUID" ]; then
  echo "ERROR: desktop '$DESKTOP_NAME' not found; run bash kde/apply-desktops.sh first" >&2
  exit 1
fi
echo "desktop '$DESKTOP_NAME' -> $DESKTOP_UUID"

rule_get() { kreadconfig6  --file "$KWINRULES" --group "$1" --key "$2"; }
rule_set() { kwriteconfig6 --file "$KWINRULES" --group "$1" --key "$2" "$3"; }

# 2) Find the rule by wmclass=devkitty (or by Description); else plan a new id
RULES_LIST="$(kreadconfig6 --file "$KWINRULES" --group General --key rules)"
RULE_ID=""
MAX_ID=0
IFS=',' read -ra IDS <<< "$RULES_LIST"
for id in "${IDS[@]}"; do
  id="${id//[[:space:]]/}"
  case "$id" in ''|*[!0-9]*) continue ;; esac
  [ "$id" -gt "$MAX_ID" ] && MAX_ID="$id"
  if [ "$(rule_get "$id" wmclass)" = "$RULE_WMCLASS" ] \
     || [ "$(rule_get "$id" Description)" = "$RULE_DESC" ]; then
    RULE_ID="$id"
  fi
done

if [ -n "$RULE_ID" ]; then
  echo "rule [$RULE_ID] already targets '$RULE_WMCLASS'; updating in place"
else
  RULE_ID=$((MAX_ID + 1))
  NEW_LIST="${RULES_LIST:+$RULES_LIST,}$RULE_ID"
  NEW_COUNT="$(awk -F',' '{print NF}' <<< "$NEW_LIST")"
  kwriteconfig6 --file "$KWINRULES" --group General --key count "$NEW_COUNT"
  kwriteconfig6 --file "$KWINRULES" --group General --key rules "$NEW_LIST"
  echo "rule [$RULE_ID] appended (count=$NEW_COUNT, rules=$NEW_LIST)"
fi

# 3) Write the rule to the REAL repo path (never to the symlink in ~/.config)
rule_set "$RULE_ID" Description     "$RULE_DESC"
rule_set "$RULE_ID" wmclass         "$RULE_WMCLASS"
rule_set "$RULE_ID" wmclassmatch    1
rule_set "$RULE_ID" wmclasscomplete true
rule_set "$RULE_ID" noborder        true
rule_set "$RULE_ID" noborderrule    2
rule_set "$RULE_ID" desktops        "$DESKTOP_UUID"
rule_set "$RULE_ID" desktopsrule    2
rule_set "$RULE_ID" fsplevel        4
rule_set "$RULE_ID" fsplevelrule    2
# KWin 6 ignores the legacy singular keys; make sure they never linger
kwriteconfig6 --file "$KWINRULES" --group "$RULE_ID" --key desktop     --delete
kwriteconfig6 --file "$KWINRULES" --group "$RULE_ID" --key desktoprule --delete
echo "rule [$RULE_ID] written to $KWINRULES"

# 4) Symlink trap check: the link in ~/.config must still point into the repo
if [ ! -L "$LINK_PATH" ]; then
  echo "ERROR: $LINK_PATH is not a symlink (kwriteconfig6 must never write there)." >&2
  echo "       fix: run bash install.sh to relink it" >&2
  exit 1
fi
LINK_TARGET="$(readlink "$LINK_PATH")"
if [ "$LINK_TARGET" != "$KWINRULES" ]; then
  echo "ERROR: $LINK_PATH -> $LINK_TARGET (expected $KWINRULES)" >&2
  exit 1
fi
echo "symlink intact: $LINK_PATH -> $LINK_TARGET"

# 5) Reload KWin and verify the rule by reading it back
qdbus6 org.kde.KWin /KWin org.kde.KWin.reconfigure >/dev/null 2>&1 || true
echo "kwin reloaded"

fail=0
check() {
  local key="$1" want="$2" got
  got="$(rule_get "$RULE_ID" "$key")"
  if [ "$got" = "$want" ]; then
    echo "verified: [$RULE_ID] $key=$got"
  else
    echo "ERROR: readback mismatch for [$RULE_ID] $key: want '$want', got '$got'" >&2
    fail=1
  fi
}
check wmclass         "$RULE_WMCLASS"
check wmclassmatch    1
check wmclasscomplete true
check noborder        true
check noborderrule    2
check desktops        "$DESKTOP_UUID"
check desktopsrule    2
check fsplevel        4
check fsplevelrule    2

# the legacy singular keys must be gone
for legacy_key in desktop desktoprule; do
  leftover="$(rule_get "$RULE_ID" "$legacy_key")"
  if [ -n "$leftover" ]; then
    echo "ERROR: legacy key [$RULE_ID] $legacy_key=$leftover still present" >&2
    fail=1
  else
    echo "verified: [$RULE_ID] legacy key $legacy_key absent"
  fi
done

# 6) No duplicate devkitty rules, and [General] rules must list our id
DUPES=0
FINAL_LIST="$(kreadconfig6 --file "$KWINRULES" --group General --key rules)"
IFS=',' read -ra FINAL_IDS <<< "$FINAL_LIST"
for id in "${FINAL_IDS[@]}"; do
  id="${id//[[:space:]]/}"
  case "$id" in ''|*[!0-9]*) continue ;; esac
  if [ "$(rule_get "$id" wmclass)" = "$RULE_WMCLASS" ]; then
    DUPES=$((DUPES + 1))
  fi
done
if [ "$DUPES" -ne 1 ]; then
  echo "ERROR: expected exactly 1 rule with wmclass=$RULE_WMCLASS, found $DUPES" >&2
  fail=1
else
  echo "verified: exactly one '$RULE_WMCLASS' rule ([General] rules=$FINAL_LIST)"
fi
case ",$FINAL_LIST," in
  *,"$RULE_ID",*) : ;;
  *) echo "ERROR: rule id $RULE_ID missing from [General] rules=$FINAL_LIST" >&2; fail=1 ;;
esac

if [ "$fail" -ne 0 ]; then
  echo "ERROR: rule verification failed; inspect $KWINRULES" >&2
  exit 1
fi

echo ""
echo "Done. Dev kitty (wmclass=$RULE_WMCLASS) is forced onto '$DESKTOP_NAME', borderless."
echo "Launcher + autostart: kde/net.local.kitty.dev.desktop (linked by install.sh)."
