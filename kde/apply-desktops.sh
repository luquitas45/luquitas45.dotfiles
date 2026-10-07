#!/usr/bin/env bash
# Ensure the two virtual desktops and their Meta shortcuts (idempotent).
#
# Desktops: 1 = "Principal", 2 = "Desarrollo". Shortcuts: Meta+Z -> desktop 1,
# Meta+X -> desktop 2. State is read live from KWin over D-Bus (ids are never
# hardcoded); only missing desktops are created and only drifted names are
# renamed. Shortcuts go through kglobalaccel's setForeignShortcut — the only
# mechanism that hot-applies on Plasma 6 — and are then verified by reading
# them back; the script exits non-zero if the readback does not match.
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

# 3) Bind the shortcuts. actionId needs 4 elements:
#    componentUnique, actionUnique, componentFriendly, actionFriendly.
for i in "${!DESKTOP_NAMES[@]}"; do
  n=$((i + 1))
  busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
    setForeignShortcut asai 4 "kwin" "Switch to Desktop $n" "KWin" "Switch to Desktop $n" \
    1 "${SHORTCUT_KEYS[$i]}" >/dev/null
  echo "shortcut set: ${SHORTCUT_LABELS[$i]} -> Switch to Desktop $n"
done

# 4) Verify: read the active keys back and fail loudly on mismatch
fail=0
for i in "${!DESKTOP_NAMES[@]}"; do
  n=$((i + 1))
  action="Switch to Desktop $n"
  block="$(qdbus6 --literal org.kde.kglobalaccel /component/kwin \
    org.kde.kglobalaccel.Component.allShortcutInfos | tr ',' '\n' \
    | grep -A9 "\"${action}\"" || true)"
  if grep -q "ai {${SHORTCUT_KEYS[$i]}}" <<<"$block"; then
    echo "verified: $action -> ${SHORTCUT_LABELS[$i]} (key ${SHORTCUT_KEYS[$i]})"
  else
    echo "ERROR: verification failed for '$action': expected active key ${SHORTCUT_KEYS[$i]} (${SHORTCUT_LABELS[$i]})" >&2
    echo "$block" >&2
    fail=1
  fi
done
if [ "$fail" -ne 0 ]; then
  echo "ERROR: shortcut verification failed; re-run or bind them in System Settings" >&2
  exit 1
fi

echo ""
echo "Done. Desktops and shortcuts verified against the live session."
