#!/usr/bin/env bash
# Generate the Gorgoroth Konsole color scheme.
#
# The scheme is generated section by section instead of by value substitution:
# the Monochrome scheme uses the same triplet (30,30,32) for [Background] and
# [Color0], which must map to different Gorgoroth values (pure black vs the
# alternate dark), so a value map cannot express it.
#
# The source file only contributes its structure (sections, key order, comments);
# every value comes from the ANSI slots of the authoritative palette,
# config/kitty/black-metal-gorgoroth.conf, so both terminals cannot drift:
#
#   [Background]        = kitty background
#   [BackgroundFaint]   = kitty color0  (the alternate, darker background)
#   [BackgroundIntense] = kitty selection_background
#   [Foreground*]       = kitty foreground / color8 / foreground
#   [ColorN]            = kitty colorN            (ANSI 0-7)
#   [ColorNIntense]     = kitty color(N+8)        (ANSI bright)
#   [ColorNFaint]       = same as [ColorN]
#
# Usage: bash kde/konsole/colorschemes/recolor.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO="$(cd "$HERE/../../.." && pwd)"
SRC="$HERE/KittyMonochrome.colorscheme"
OUT="$HERE/Gorgoroth.colorscheme"
KITTY="$REPO/config/kitty/black-metal-gorgoroth.conf"
[ -f "$SRC" ] || { echo "missing $SRC" >&2; exit 1; }
[ -f "$KITTY" ] || { echo "missing $KITTY" >&2; exit 1; }

kitty_hex() { grep -E "^$1 " "$KITTY" | head -1 | awk '{print $2}'; }
hex2rgb() { printf '%d,%d,%d' "$((16#${1:1:2}))" "$((16#${1:3:2}))" "$((16#${1:5:2}))"; }

declare -A SLOT
SLOT[Background]="$(hex2rgb "$(kitty_hex background)")"
SLOT[BackgroundFaint]="$(hex2rgb "$(kitty_hex color0)")"
SLOT[BackgroundIntense]="$(hex2rgb "$(kitty_hex selection_background)")"
SLOT[Foreground]="$(hex2rgb "$(kitty_hex foreground)")"
SLOT[ForegroundFaint]="$(hex2rgb "$(kitty_hex color8)")"
SLOT[ForegroundIntense]="$(hex2rgb "$(kitty_hex foreground)")"
for i in 0 1 2 3 4 5 6 7; do
  SLOT["Color$i"]="$(hex2rgb "$(kitty_hex "color$i")")"
  SLOT["Color${i}Faint"]="${SLOT["Color$i"]}"
  SLOT["Color${i}Intense"]="$(hex2rgb "$(kitty_hex "color$((i + 8))")")"
done

echo "== Gorgoroth: generate Konsole scheme =="

sec=""
while IFS= read -r line; do
  case "$line" in
    \[*) sec="${line#[}"; sec="${sec%]}" ;;
  esac
  if [ "${line%%=*}" = "Color" ] && [ -n "${SLOT[$sec]:-}" ]; then
    echo "Color=${SLOT[$sec]}"
  else
    echo "$line"
  fi
done < "$SRC" > "$OUT"

echo "generated: kde/konsole/colorschemes/Gorgoroth.colorscheme"
echo "  background $(kitty_hex background) · foreground $(kitty_hex foreground) · color1 $(kitty_hex color1) (teal)"
echo ""
echo "Done. Run kde/konsole/colorschemes/verify.sh to check every slot."
