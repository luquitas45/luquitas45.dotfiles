#!/usr/bin/env bash
# Dev kitty launcher (autostart + menu).
#
# Opens kitty with class devkitty running/attaching the tmux session "dev" and
# makes sure it ends up on the "Desarrollo" desktop WITHOUT dragging the current
# desktop there.
#
# Why not a KWin window rule: a "force desktop" rule makes KWin follow the new
# window to Desarrollo (it steals the desktop on login). Moving the window after
# it exists does not switch the desktop, so we load a tiny KWin script that
# moves every devkitty window (see devkitty-to-desarrollo.js next to this file).
#
# Usage: dev-kitty.sh
set -uo pipefail

KITTY=/usr/bin/kitty
SCRIPT_NAME="devkitty-to-desarrollo"
HERE="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
HELPER="$HERE/devkitty-to-desarrollo.js"

# Launch the dev kitty on the current desktop. It must NOT be born on Desarrollo
# or KWin would follow it there.
setsid "$KITTY" --class devkitty --title Dev tmux new-session -A -s dev >/dev/null 2>&1 &

# Load the KWin helper once per session; it also fixes the window that just
# appeared (it scans the existing windows when it loads).
loaded="$(qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.isScriptLoaded "$SCRIPT_NAME" 2>/dev/null)"
if [ "$loaded" != "true" ]; then
  qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "$HELPER" "$SCRIPT_NAME" >/dev/null 2>&1 || true
  qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.start >/dev/null 2>&1 || true
fi

exit 0
