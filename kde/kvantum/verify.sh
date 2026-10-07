#!/usr/bin/env bash
# Verify the derived Gorgoroth Kvantum themes.
#
# Fails if a derived theme still contains a legacy Monochrome hex (except
# identity pairs, which the palette shares, and the functional #ff00ff marker),
# and asserts a few expected Gorgoroth roles are present.
#
# Usage: bash kde/kvantum/verify.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAP="$HERE/palette.map"
fail=0

shopt -s nullglob
files=("$HERE"/Gorgoroth*/Gorgoroth*.svg "$HERE"/Gorgoroth*/Gorgoroth*.kvconfig)
if [ "${#files[@]}" -eq 0 ]; then
  echo "FAIL: no derived themes found (run kde/kvantum/recolor.sh first)" >&2
  exit 1
fi

echo "== Gorgoroth: verify Kvantum themes =="

while read -r old new _; do
  [ -n "${old:-}" ] || continue
  case "$old" in \#*) continue ;; esac
  [ "${old,,}" = "${new,,}" ] && continue      # identity pair: shared palette
  for f in "${files[@]}"; do
    if grep -qi -- "#$old" "$f"; then
      echo "LEGACY  #$old  in  ${f#"$HERE"/}"
      fail=1
    fi
  done
done < "$MAP"

assert() { grep -qi -- "$1" "$2" || { echo "MISSING  $1  in  ${2#"$HERE"/}"; fail=1; }; }
for d in Gorgoroth GorgorothBlur GorgorothSolid; do
  k="$HERE/$d/$d.kvconfig"
  [ -f "$k" ] || { echo "MISSING  $k"; fail=1; continue; }
  assert 'window.color=#000000'      "$k"
  assert 'alt.base.color=#2a2325'    "$k"
  assert 'text.color=#c1c1c1'        "$k"
  assert 'highlight.color=#5f8787'   "$k"
  assert 'highlight.text.color=#000000' "$k"
done

if [ "$fail" -eq 0 ]; then
  echo "verify OK: ${#files[@]} derived files, no legacy Monochrome hexes"
else
  echo "verify FAILED"
fi
exit "$fail"
