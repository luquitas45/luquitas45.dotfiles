#!/usr/bin/env bash
# Verify the derived Gorgoroth Aurorae decoration.
#
# Fails if the derived theme still contains a legacy Monochrome hex or RGB
# triplet (except identity pairs and the functional white text shadow), and
# asserts the metadata ids match the directory so __aurorae__svg__Gorgoroth
# resolves.
#
# Usage: bash kde/aurorae/verify.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAP="$HERE/palette.map"
OUT="$HERE/Gorgoroth"
fail=0

shopt -s nullglob
svgfiles=("$OUT"/*.svg)
if [ ! -f "$OUT/Gorgorothrc" ] || [ "${#svgfiles[@]}" -eq 0 ]; then
  echo "FAIL: derived theme missing (run kde/aurorae/recolor.sh first)" >&2
  exit 1
fi

echo "== Gorgoroth: verify Aurorae decoration =="

hex2rgb() { printf '%d,%d,%d' "$((16#${1:0:2}))" "$((16#${1:2:2}))" "$((16#${1:4:2}))"; }

while read -r old new _; do
  [ -n "${old:-}" ] || continue
  case "$old" in \#*) continue ;; esac
  [ "${old,,}" = "${new,,}" ] && continue

  # SVGs: hex form
  for f in "${svgfiles[@]}"; do
    if grep -qi -- "#$old" "$f"; then
      echo "LEGACY  #$old  in  ${f#"$HERE"/}"
      fail=1
    fi
  done

  # rc: RGB triplet form (skip the functional white shadow)
  rgb="$(hex2rgb "$old")"
  if [ "$rgb" != "255,255,255" ] && grep -q -- "$rgb" "$OUT/Gorgorothrc"; then
    echo "LEGACY  $rgb  in  Gorgoroth/Gorgorothrc"
    fail=1
  fi
done < "$MAP"

assert() { grep -q -- "$1" "$2" || { echo "MISSING  $1  in  ${2#"$HERE"/}"; fail=1; }; }
assert '"Id": "Gorgoroth"'              "$OUT/metadata.json"
assert 'X-KDE-PluginInfo-Name=Gorgoroth' "$OUT/metadata.desktop"
assert 'ActiveTextColor=193,193,193'    "$OUT/Gorgorothrc"
assert 'InactiveTextColor=136,136,136'  "$OUT/Gorgorothrc"
assert 'ActiveFocusedTabColor=80,80,80' "$OUT/Gorgorothrc"
assert 'ActiveTextShadowColor=255,255,255,255' "$OUT/Gorgorothrc"
assert 'InactiveTextShadowColor=255,255,255,255' "$OUT/Gorgorothrc"

if [ "$fail" -eq 0 ]; then
  echo "verify OK: ${#svgfiles[@]} SVGs + Gorgorothrc, no legacy Monochrome values"
else
  echo "verify FAILED"
fi
exit "$fail"
