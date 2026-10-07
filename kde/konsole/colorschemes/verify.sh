#!/usr/bin/env bash
# Verify the generated Gorgoroth Konsole scheme against the authoritative kitty
# palette: every ANSI slot (normal and bright), the background and the
# foreground must match config/kitty/black-metal-gorgoroth.conf.
#
# Usage: bash kde/konsole/colorschemes/verify.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
OUT="$HERE/Gorgoroth.colorscheme"
KITTY="$REPO/config/kitty/black-metal-gorgoroth.conf"
fail=0

[ -f "$OUT" ] || { echo "FAIL: $OUT missing (run recolor.sh first)" >&2; exit 1; }

echo "== Gorgoroth: verify Konsole scheme =="

kitty_hex() { grep -E "^$1 " "$KITTY" | head -1 | awk '{print $2}'; }
hex2rgb() { printf '%d,%d,%d' "$((16#${1:1:2}))" "$((16#${1:3:2}))" "$((16#${1:5:2}))"; }
scheme_value() { sed -n "/^\[$1\]/,/^\[/p" "$OUT" | grep -m1 '^Color=' | cut -d= -f2; }

check() { # section kitty-slot-name
  local want got
  want="$(hex2rgb "$(kitty_hex "$2")")"
  got="$(scheme_value "$1")"
  if [ "$want" != "$got" ]; then
    echo "SLOT  [$1]  esperado $want (kitty $2 = $(kitty_hex "$2")), obtuve '${got:-<vacío>}'"
    fail=1
  fi
}

check Background background
check Foreground foreground
for i in 0 1 2 3 4 5 6 7; do
  check "Color$i" "color$i"
  check "Color${i}Intense" "color$((i + 8))"
done

# the source's structure must survive
for sec in Background BackgroundFaint BackgroundIntense Foreground ForegroundFaint ForegroundIntense; do
  [ -n "$(scheme_value "$sec")" ] || { echo "MISSING  [$sec]"; fail=1; }
done

if [ "$fail" -eq 0 ]; then
  echo "verify OK: 8 ANSI slots + 8 bright + background/foreground match kitty exactly"
else
  echo "verify FAILED"
fi
exit "$fail"
