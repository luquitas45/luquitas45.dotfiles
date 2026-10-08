#!/usr/bin/env bash
# Dev kitty launcher (manual + Meta+X command shortcut). Idempotent.
#
# Opens kitty with class devkitty running/attaching the tmux session "dev".
# Reuse guard: if a devkitty kitty is already running it exits 0 instead of
# opening a duplicate. Entering Desarrollo is done first by kde/dev-desktop.sh;
# this script only launches the window and ensures the KWin helper is loaded.
#
# The KWin helper (see devkitty-to-desarrollo.js next to this file) keeps every
# devkitty window borderless and on Desarrollo. It is loaded on every run --
# including reuse -- so it always guarantees noborder/placement.
#
# Usage: dev-kitty.sh
set -uo pipefail

KITTY=/usr/bin/kitty
SCRIPT_NAME="devkitty-to-desarrollo"
HERE="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
HELPER="$HERE/devkitty-to-desarrollo.js"

ensure_helper() {
  local loaded
  loaded="$(qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.isScriptLoaded "$SCRIPT_NAME" 2>/dev/null)"
  if [ "$loaded" != "true" ]; then
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.loadScript "$HELPER" "$SCRIPT_NAME" >/dev/null 2>&1 || true
    qdbus6 org.kde.KWin /Scripting org.kde.kwin.Scripting.start >/dev/null 2>&1 || true
  fi
}

# Reuse an already running dev kitty instead of opening a duplicate. The bracket
# in the pattern keeps pgrep from matching its own command line.
if pgrep -f -- '--class[= ]devkitty' >/dev/null 2>&1; then
  ensure_helper
  exit 0
fi

# Launch the dev kitty on the current desktop.
setsid "$KITTY" --class devkitty --title Dev tmux new-session -A -s dev >/dev/null 2>&1 &

# Load the KWin helper once per session; it also fixes the window that just
# appeared (it scans the existing windows when it loads).
ensure_helper

exit 0
