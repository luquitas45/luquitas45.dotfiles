#!/usr/bin/env bash
# Dev kitty command shortcut entrypoint: enter "Desarrollo", then launch/reuse.
#
# The desktop is switched FIRST on purpose: a freshly launched devkitty window is
# then born on Desarrollo. The KWin helper (devkitty-to-desarrollo.js) only
# guarantees noborder/placement for windows that already exist -- moving a
# window never switches the active desktop -- so placement is not delegated to
# it here. The launcher is a sibling of this script, resolved from BASH_SOURCE,
# so no home path is hardcoded. The desktop uuid is read live from KWin.
#
# Usage: dev-desktop.sh
set -euo pipefail

for cmd in qdbus6 busctl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd not found (a live Plasma 6 session is required)" >&2
    exit 1
  fi
done

# Emit "position<TAB>uuid<TAB>name" per desktop, in KWin order, then pick the
# uuid of the desktop named "Desarrollo". Nothing is hardcoded.
target_uuid="$(
  qdbus6 --literal org.kde.KWin /VirtualDesktopManager \
    org.kde.KWin.VirtualDesktopManager.desktops \
    | grep -oP '\(uss\) \d+, "[^"]+", "[^"]+"' \
    | sed 's/(uss) \([0-9]\+\), "\([^"]*\)", "\([^"]*\)"/\1\t\2\t\3/' \
    | awk -F '\t' '$3 == "Desarrollo" { print $2; exit }'
)"

if [ -z "$target_uuid" ]; then
  echo "ERROR: no virtual desktop named 'Desarrollo' found (run: bash kde/apply-desktops.sh)" >&2
  exit 1
fi

busctl --user set-property org.kde.KWin /VirtualDesktopManager \
  org.kde.KWin.VirtualDesktopManager current s "$target_uuid"

HERE="$(cd "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")" && pwd)"
exec "$HERE/dev-kitty.sh"
