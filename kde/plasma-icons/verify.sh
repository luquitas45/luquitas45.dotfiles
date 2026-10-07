#!/usr/bin/env bash
# Verify the Gorgoroth Plasma shell icons carry no Breeze leftover.
#
# Checks both halves: the painted literals and the inert
# `<style id="current-color-scheme">` placeholders (the map covers both, so a
# plain grep must come out clean), and asserts a few expected roles.
#
# Usage: bash kde/plasma-icons/verify.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
ICONS="$REPO/plasma/desktoptheme/gorgoroth/icons"
MAP="$HERE/palette.map"
fail=0

shopt -s nullglob
svgs=("$ICONS"/*.svg)
[ "${#svgs[@]}" -gt 0 ] || { echo "FAIL: no icons found in $ICONS" >&2; exit 1; }

echo "== Gorgoroth: verify Plasma shell icons =="

while read -r old new _; do
  [ -n "${old:-}" ] || continue
  case "$old" in \#*) continue ;; esac
  [ "${old,,}" = "${new,,}" ] && continue      # identity: shared with the palette
  for f in "${svgs[@]}"; do
    if grep -qi -- "#$old" "$f"; then
      echo "LEGACY  #$old  in  ${f##*/}"
      fail=1
    fi
  done
done < "$MAP"

assert() { grep -q -- "$1" "$2" || { echo "MISSING  $1  in  ${2##*/}"; fail=1; }; }
# the OSD popups paint the accent now, and the semantic fills use the palette
assert '#5f8787' "$ICONS/osd.svg"
assert '#ddeecc' "$ICONS/fcitx.svg"
assert '#9b8d7f' "$ICONS/network.svg"
assert '#8a4f4f' "$ICONS/battery.svg"

if [ "$fail" -eq 0 ]; then
  echo "verify OK: ${#svgs[@]} icons, no Breeze leftover (painted or placeholder)"
else
  echo "verify FAILED"
fi
exit "$fail"
