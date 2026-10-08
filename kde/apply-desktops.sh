#!/usr/bin/env bash
# Ensure the two virtual desktops and the Meta+Z / Meta+X shortcuts (idempotent).
#
# Desktops: 1 = "Principal", 2 = "Desarrollo". State is read live from KWin over
# D-Bus (ids are never hardcoded); only missing desktops are created and only
# drifted names are renamed.
#
# Shortcuts are split across two components, both hot-applied through
# kglobalaccel (the only mechanism that applies without a re-login):
#   Meta+Z -> KWin "Switch to Desktop 1" (Principal).
#   Meta+X -> command shortcut net.local.dev-desktop.desktop/_launch, which
#             enters Desarrollo and launches/reuses the dev kitty.
# The dev command shortcut is registered (doRegister) and bound BEFORE Meta+X
# is freed from KWin's "Switch to Desktop 2", so the key is never dead in
# between. The result is verified by reading the shortcuts back; the script
# exits non-zero if the readback does not match.
#
# Usage: bash kde/apply-desktops.sh
set -euo pipefail

DESKTOP_NAMES=("Principal" "Desarrollo")
SHORTCUT_LABELS=("Meta+Z" "Meta+X")
# Qt key codes: Qt::META (0x10000000) | Qt::Key_Z (0x5a) / Qt::Key_X (0x58)
SHORTCUT_KEYS=(268435546 268435544)

echo "== Virtual desktops: Principal / Desarrollo =="

for cmd in qdbus6 busctl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd not found (a live Plasma 6 session is required)" >&2
    exit 1
  fi
done

# Emit "position<TAB>uuid<TAB>name" per desktop, in KWin order.
read_desktops() {
  qdbus6 --literal org.kde.KWin /VirtualDesktopManager \
    org.kde.KWin.VirtualDesktopManager.desktops \
    | grep -oP '\(uss\) \d+, "[^"]+", "[^"]+"' \
    | sed 's/(uss) \([0-9]\+\), "\([^"]*\)", "\([^"]*\)"/\1\t\2\t\3/'
}

desktop_count() {
  qdbus6 org.kde.KWin /VirtualDesktopManager org.kde.KWin.VirtualDesktopManager.count
}

# 1) Create only the missing desktops (createDesktop takes a 0-based position)
count="$(desktop_count)"
for i in "${!DESKTOP_NAMES[@]}"; do
  if [ "$count" -le "$i" ]; then
    qdbus6 org.kde.KWin /VirtualDesktopManager \
      org.kde.KWin.VirtualDesktopManager.createDesktop "$i" "${DESKTOP_NAMES[$i]}" >/dev/null
    echo "desktop $((i + 1)) created: ${DESKTOP_NAMES[$i]}"
    count="$(desktop_count)"
  fi
done

# 2) Name desktops 1 and 2 idempotently (by position; ids read at runtime)
seen=0
while IFS=$'\t' read -r pos uuid name; do
  if [ "$pos" -ge "${#DESKTOP_NAMES[@]}" ]; then
    break
  fi
  want="${DESKTOP_NAMES[$pos]}"
  if [ "$name" = "$want" ]; then
    echo "desktop $((pos + 1)) already named: $want"
  else
    qdbus6 org.kde.KWin /VirtualDesktopManager \
      org.kde.KWin.VirtualDesktopManager.setDesktopName "$uuid" "$want"
    echo "desktop $((pos + 1)) renamed: '$name' -> '$want'"
  fi
  seen=$((seen + 1))
done < <(read_desktops)

if [ "$seen" -lt "${#DESKTOP_NAMES[@]}" ]; then
  echo "ERROR: only $seen desktop(s) visible after the create step" >&2
  exit 1
fi

# 3) Shortcuts. actionId needs 4 elements:
#    componentUnique, actionUnique, componentFriendly, actionFriendly.
DEV_COMPONENT="net.local.dev-desktop.desktop"
DEV_ACTION="_launch"
DEV_NAME="Kitty Dev (Desarrollo)"

# Meta+X -> dev command shortcut. Register the component first (a command
# shortcut needs doRegister), then bind it hot. This happens BEFORE KWin's
# "Switch to Desktop 2" is freed, so Meta+X is never unbound in between.
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  doRegister as 4 "$DEV_COMPONENT" "$DEV_ACTION" "$DEV_NAME" "$DEV_NAME" >/dev/null
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  setForeignShortcut asai 4 "$DEV_COMPONENT" "$DEV_ACTION" "$DEV_NAME" "$DEV_NAME" \
  1 "${SHORTCUT_KEYS[1]}" >/dev/null
echo "shortcut set: ${SHORTCUT_LABELS[1]} -> $DEV_NAME (command shortcut)"

# Meta+Z stays on KWin desktop 1 (Principal).
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  setForeignShortcut asai 4 "kwin" "Switch to Desktop 1" "KWin" "Switch to Desktop 1" \
  1 "${SHORTCUT_KEYS[0]}" >/dev/null
echo "shortcut set: ${SHORTCUT_LABELS[0]} -> Switch to Desktop 1"

# Free Meta+X from KWin desktop 2 (an empty key array unbinds it).
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  setForeignShortcut asai 4 "kwin" "Switch to Desktop 2" "KWin" "Switch to Desktop 2" \
  0 >/dev/null
echo "shortcut freed: Switch to Desktop 2"

# 4) Verify: read the active keys back and fail loudly on mismatch.
fail=0

read_action_block() {
  local component="$1" action="$2"
  qdbus6 --literal org.kde.kglobalaccel "/component/$component" \
    org.kde.kglobalaccel.Component.allShortcutInfos | tr ',' '\n' \
    | grep -A9 "\"${action}\"" || true
}

expect_key() {
  local component="$1" action="$2" label="$3" key="$4" block
  block="$(read_action_block "$component" "$action")"
  if grep -q "ai {${key}}" <<<"$block"; then
    echo "verified: $label -> key ${key}"
  else
    echo "ERROR: verification failed: '$label' is not bound to key ${key}" >&2
    echo "$block" >&2
    fail=1
  fi
}

expect_no_key() {
  local component="$1" action="$2" label="$3" key="$4" block
  block="$(read_action_block "$component" "$action")"
  if grep -q "ai {${key}}" <<<"$block"; then
    echo "ERROR: verification failed: '$label' is still bound to key ${key}" >&2
    echo "$block" >&2
    fail=1
  else
    echo "verified: $label is free of key ${key}"
  fi
}

expect_key "kwin" "Switch to Desktop 1" "${SHORTCUT_LABELS[0]} (Switch to Desktop 1)" "${SHORTCUT_KEYS[0]}"
expect_key "net_local_dev_desktop_desktop" "$DEV_ACTION" "${SHORTCUT_LABELS[1]} ($DEV_NAME)" "${SHORTCUT_KEYS[1]}"
expect_no_key "kwin" "Switch to Desktop 2" "Switch to Desktop 2" "${SHORTCUT_KEYS[1]}"

if [ "$fail" -ne 0 ]; then
  echo "ERROR: shortcut verification failed; re-run or bind them in System Settings" >&2
  exit 1
fi

echo ""
echo "Done. Desktops and shortcuts verified against the live session."
