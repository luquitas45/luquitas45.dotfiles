#!/usr/bin/env bash
# Recolor the vendored Monochrome Yakuake skin into Gorgoroth.
#
# Deterministic and idempotent: reads skins/upstream-monochrome plus palette.map
# and (re)generates skins/Gorgoroth. The upstream copy is never touched.
#
# Three color forms are handled:
#   - hex in every SVG (including logo.svg)
#   - the per-component text color in title.skin / tabs.skin
#     (the format is `red=170` / `green=170` / `blue=172`, not a comma triplet)
#   - one file-scoped override: the active tab takes the teal accent
#
# Usage: bash kde/yakuake/recolor.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/skins/upstream-monochrome"
OUT="$HERE/skins/Gorgoroth"
MAP="$HERE/palette.map"
ACCENT="#5f8787"
[ -f "$MAP" ] || { echo "missing $MAP" >&2; exit 1; }

pairs() {
  awk '!/^[[:space:]]*#/ && NF >= 2 && tolower($1) != tolower($2) { print $1, $2 }' "$MAP"
}

MAP_SED="$(pairs | while read -r o n; do printf 's/#%s/#%s/Ig\n' "$o" "$n"; done)"

# Same mapping, component by component, for the .skin files.
map_components() {
  local o n or_ og ob nr ng nb
  while read -r o n; do
    or_=$((16#${o:0:2})); og=$((16#${o:2:2})); ob=$((16#${o:4:2}))
    nr=$((16#${n:0:2}));  ng=$((16#${n:2:2}));  nb=$((16#${n:4:2}))
    [ "$or_" = "$nr" ] || printf 's/^red=%s$/red=%s/\n'   "$or_" "$nr"
    [ "$og"  = "$ng" ] || printf 's/^green=%s$/green=%s/\n' "$og"  "$ng"
    [ "$ob"  = "$nb" ] || printf 's/^blue=%s$/blue=%s/\n'  "$ob"  "$nb"
  done < <(pairs)
}
MAP_SED_COMP="$(map_components)"

echo "== Gorgoroth: recolor Yakuake skin =="

rm -rf "$OUT"
mkdir -p "$OUT"
mkdir -p "$OUT/title" "$OUT/tabs"
cp "$SRC/AUTHORS" "$SRC/LICENSE" "$OUT/"

for dir in title tabs; do
  for f in "$SRC/$dir"/*.svg; do
    sed "$MAP_SED" "$f" > "$OUT/$dir/$(basename "$f")"
  done
done
sed "$MAP_SED" "$SRC/logo.svg" > "$OUT/logo.svg"

# title.skin / tabs.skin: per-component text color
sed "$MAP_SED_COMP" "$SRC/title.skin" > "$OUT/title.skin"
sed "$MAP_SED_COMP" "$SRC/tabs.skin"  > "$OUT/tabs.skin"

# the active tab carries the accent instead of the mapped foreground
sed -i "s/#c1c1c1/$ACCENT/Ig" "$OUT/tabs/tab_selected.svg"

echo "generated: kde/yakuake/skins/Gorgoroth"
echo "  text color: $(sed -n '/^\[Text\]/,/^\[/p' "$OUT/title.skin" | grep -E '^(red|green|blue)=' | tr '\n' ' ')"
echo "  active tab accent: $ACCENT"
echo ""
echo "Done. Run kde/yakuake/verify.sh to check the result."
