#!/usr/bin/env bash
# Dev kitty launcher (autostart + menu).
#
# Opens kitty with class devkitty running/attaching the tmux session "dev".
# A KWin rule forces that window onto the "Desarrollo" desktop. KWin follows a
# new window on another desktop, so this wrapper returns the current desktop to
# the one in effect before the launch.
#
# Usage: dev-kitty.sh
set -uo pipefail

KITTY=/usr/bin/kitty
DEV_DESKTOP_NAME="Desarrollo"
POLL_TRIES=20
POLL_SLEEP=0.25

current_desktop() {
  qdbus6 org.kde.KWin /VirtualDesktopManager \
    org.kde.KWin.VirtualDesktopManager.current 2>/dev/null
}

desktop_uuid_by_name() {
  qdbus6 --literal org.kde.KWin /VirtualDesktopManager \
    org.kde.KWin.VirtualDesktopManager.desktops 2>/dev/null \
    | grep -oP '\(uss\) \d+, "[^"]+", "[^"]+"' \
    | sed 's/(uss) \([0-9]\+\), "\([^"]*\)", "\([^"]*\)"/\1\t\2\t\3/' \
    | awk -F'\t' -v want="$1" '$3 == want { print $2; exit }'
}

prev="$(current_desktop)"
dev="$(desktop_uuid_by_name "$DEV_DESKTOP_NAME")"

setsid "$KITTY" --class devkitty --title Dev tmux new-session -A -s dev >/dev/null 2>&1 &

# Let KWin map the window and apply the rule; if it followed it to Desarrollo,
# put the desktop back where it was.
if [ -n "$prev" ] && [ -n "$dev" ] && [ "$prev" != "$dev" ]; then
  for _ in $(seq "$POLL_TRIES"); do
    now="$(current_desktop)"
    if [ "$now" = "$dev" ]; then
      busctl --user set-property org.kde.KWin /VirtualDesktopManager \
        org.kde.KWin.VirtualDesktopManager current s "$prev" >/dev/null 2>&1
      break
    fi
    [ "$now" != "$prev" ] && break   # something else moved it: do not fight
    sleep "$POLL_SLEEP"
  done
fi

exit 0
