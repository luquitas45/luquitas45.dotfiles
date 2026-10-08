#!/usr/bin/env bash
# Recolor the Gorgoroth Plasma shell icons: Breeze leftovers -> Gorgoroth palette.
#
# This is a migration, not an upstream/derived pipeline: the icons shipped in
# plasma/desktoptheme/gorgoroth/icons/ are already the theme's own assets (the
# earlier blue -> teal pass happened before they reached the repo, so there is no
# pristine input to re-derive from). The script runs in place and is idempotent:
# a second run finds no legacy color and changes nothing.
#
# It rewrites every literal hex, including the inert
# `<style id="current-color-scheme">` placeholders, so a `grep` over the
# directory never suggests the theme is off-palette. See palette.map for the
# role of each entry and why the placeholder half does not affect rendering.
#
# Usage: bash kde/plasma-icons/recolor.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../.." && pwd)"
ICONS="$REPO/plasma/desktoptheme/gorgoroth/icons"
MAP="$HERE/palette.map"
[ -f "$MAP" ] || { echo "missing $MAP" >&2; exit 1; }
[ -d "$ICONS" ] || { echo "missing $ICONS" >&2; exit 1; }

MAP_SED="$(awk '!/^[[:space:]]*#/ && NF >= 2 { if (tolower($1) != tolower($2)) printf "s/#%s/#%s/Ig\n", $1, $2 }' "$MAP")"

echo "== Gorgoroth: recolor Plasma shell icons =="
changed=0
for f in "$ICONS"/*.svg; do
  before="$(md5sum "$f" | cut -d' ' -f1)"
  sed -i "$MAP_SED" "$f"
  after="$(md5sum "$f" | cut -d' ' -f1)"
  [ "$before" = "$after" ] || changed=$((changed + 1))
done

echo "  files changed: $changed of $(ls "$ICONS"/*.svg | wc -l)"
echo ""
echo "Done. Run kde/plasma-icons/verify.sh to check the result."
