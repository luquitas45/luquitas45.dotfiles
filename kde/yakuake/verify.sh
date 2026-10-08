#!/usr/bin/env bash
# Verify the derived Gorgoroth Yakuake skin.
#
# Fails if a derived file still carries a legacy Monochrome hex (any SVG,
# including logo.svg) or a legacy per-component text value, and asserts the
# expected Gorgoroth roles.
#
# Usage: bash kde/yakuake/verify.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAP="$HERE/palette.map"
OUT="$HERE/skins/Gorgoroth"
ACCENT="#5f8787"
fail=0

shopt -s nullglob
svgs=("$OUT"/*.svg "$OUT"/*/*.svg)
if [ ! -f "$OUT/title.skin" ] || [ "${#svgs[@]}" -eq 0 ]; then
  echo "FAIL: derived skin missing (run kde/yakuake/recolor.sh first)" >&2
  exit 1
fi

echo "== Gorgoroth: verify Yakuake skin =="

while read -r old new _; do
  [ -n "${old:-}" ] || continue
  case "$old" in \#*) continue ;; esac
  [ "${old,,}" = "${new,,}" ] && continue

  for f in "${svgs[@]}"; do
    if grep -qi -- "#$old" "$f"; then
      echo "LEGACY  #$old  in  ${f#"$HERE"/}"
      fail=1
    fi
  done

  # per-component values in the .skin files
  local_o=$((16#${old:0:2})); local_g=$((16#${old:2:2})); local_b=$((16#${old:4:2}))
  local_no=$((16#${new:0:2})); local_ng=$((16#${new:2:2})); local_nb=$((16#${new:4:2}))
  for f in "$OUT/title.skin" "$OUT/tabs.skin"; do
    if [ "$local_o" != "$local_no" ] && grep -qE "^red=$local_o$" "$f"; then
      echo "LEGACY  red=$local_o  in  ${f#"$HERE"/}"; fail=1
    fi
    if [ "$local_g" != "$local_ng" ] && grep -qE "^green=$local_g$" "$f"; then
      echo "LEGACY  green=$local_g  in  ${f#"$HERE"/}"; fail=1
    fi
    if [ "$local_b" != "$local_nb" ] && grep -qE "^blue=$local_b$" "$f"; then
      echo "LEGACY  blue=$local_b  in  ${f#"$HERE"/}"; fail=1
    fi
  done
done < "$MAP"

assert() { grep -q -- "$1" "$2" || { echo "MISSING  $1  in  ${2#"$HERE"/}"; fail=1; }; }
for t in title tabs; do
  assert 'red=193'   "$OUT/$t.skin"
  assert 'green=193' "$OUT/$t.skin"
  assert 'blue=193'  "$OUT/$t.skin"
done
assert "$ACCENT" "$OUT/tabs/tab_selected.svg"
for f in AUTHORS LICENSE; do
  [ -f "$OUT/$f" ] || { echo "MISSING  $OUT/$f"; fail=1; }
done

if [ "$fail" -eq 0 ]; then
  echo "verify OK: ${#svgs[@]} SVGs + 2 .skin files, no legacy Monochrome values"
else
  echo "verify FAILED"
fi
exit "$fail"
