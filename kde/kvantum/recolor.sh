#!/usr/bin/env bash
# Recolor the vendored Monochrome Kvantum themes into the Gorgoroth palette.
#
# Deterministic and idempotent: reads upstream-monochrome/ plus palette.map and
# (re)generates Gorgoroth, GorgorothBlur and GorgorothSolid. The upstream
# copies are never touched.
#
# Usage: bash kde/kvantum/recolor.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/upstream-monochrome"
MAP="$HERE/palette.map"
[ -f "$MAP" ] || { echo "missing $MAP" >&2; exit 1; }

# Build one sed script from the non-identity map entries.
MAP_SED="$(awk '!/^[[:space:]]*#/ && NF >= 2 { if (tolower($1) != tolower($2)) printf "s/#%s/#%s/Ig\n", $1, $2 }' "$MAP")"

echo "== Gorgoroth: recolor Kvantum themes =="

for old in Monochrome MonochromeBlur MonochromeSolid; do
  case "$old" in
    Monochrome)      new=Gorgoroth ;;
    MonochromeBlur)  new=GorgorothBlur ;;
    MonochromeSolid) new=GorgorothSolid ;;
  esac
  src="$SRC/$old"
  out="$HERE/$new"
  [ -d "$src" ] || { echo "missing upstream theme: $src" >&2; exit 1; }

  rm -rf "$out"
  mkdir -p "$out"
  cp "$src/AUTHORS" "$src/LICENSE" "$out/"

  sed "$MAP_SED" "$src/$old.svg"     > "$out/$new.svg"
  sed "$MAP_SED" "$src/$old.kvconfig" > "$out/$new.kvconfig"

  # Role overrides and attribution, applied after the generic hex pass.
  sed -i \
    -e 's/^alt\.base\.color=.*/alt.base.color=#2a2325/' \
    -e 's/^highlight\.text\.color=.*/highlight.text.color=#000000/' \
    -e 's/^comment=.*/comment=Gorgoroth: recolored from "Monochrome" by Patrik Wyde to the Black Metal Gorgoroth palette./' \
    "$out/$new.kvconfig"

  echo "generated: kde/kvantum/$new ($(du -sh "$out" | cut -f1))"
done

echo ""
echo "Done. Run kde/kvantum/verify.sh to check the result."
