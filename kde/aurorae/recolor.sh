#!/usr/bin/env bash
# Recolor the vendored Monochrome Aurorae decoration into Gorgoroth.
#
# Deterministic and idempotent: reads upstream-monochrome/Monochrome plus
# palette.map and (re)generates kde/aurorae/Gorgoroth (SVGs + Gorgorothrc +
# metadata). The upstream copy is never touched.
#
# Only the non-blur variant is derived: the live session uses
# __aurorae__svg__Monochrome. MonochromeBlur stays vendored as-is (its upstream
# metadata id contains a space, which does not round-trip cleanly).
#
# Usage: bash kde/aurorae/recolor.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$HERE/upstream-monochrome/Monochrome"
OUT="$HERE/Gorgoroth"
MAP="$HERE/palette.map"
[ -f "$MAP" ] || { echo "missing $MAP" >&2; exit 1; }

pairs() {
  awk '!/^[[:space:]]*#/ && NF >= 2 && tolower($1) != tolower($2) { print $1, $2 }' "$MAP"
}
hex2rgb() { printf '%d,%d,%d' "$((16#${1:0:2}))" "$((16#${1:2:2}))" "$((16#${1:4:2}))"; }

MAP_SED="$(pairs | while read -r o n; do printf 's/#%s/#%s/Ig\n' "$o" "$n"; done)"
MAP_SED_RGB="$(pairs | while read -r o n; do printf 's/%s/%s/g\n' "$(hex2rgb "$o")" "$(hex2rgb "$n")"; done)"

echo "== Gorgoroth: recolor Aurorae decoration =="

rm -rf "$OUT"
mkdir -p "$OUT"
cp "$SRC/AUTHORS" "$SRC/LICENSE" "$OUT/"

for f in "$SRC"/*.svg; do
  sed "$MAP_SED" "$f" > "$OUT/$(basename "$f")"
done

sed "$MAP_SED_RGB" "$SRC/Monochromerc" > "$OUT/Gorgorothrc"
# The white text shadow is functional in the upstream theme: keep it as-is.
sed -i -E 's/^([A-Za-z]*)TextShadowColor=.*/\1TextShadowColor=255,255,255,255/' "$OUT/Gorgorothrc"

cat > "$OUT/metadata.json" <<'JSON'
{
    "KPackageStructure": "KWin/Aurorae",
    "KPlugin": {
        "Authors": [
            {
                "Email": "patrik@wyde.se",
                "Name": "Patrik Wyde"
            }
        ],
        "Category": "Plasma Window Decorations",
        "Description": "Gorgoroth: recolored from \"Monochrome\" by Patrik Wyde to the Black Metal Gorgoroth palette.",
        "EnabledByDefault": true,
        "Id": "Gorgoroth",
        "License": "GPLv3",
        "Name": "Gorgoroth",
        "ServiceTypes": [
            "KWin/Aurorae"
        ],
        "Version": "1.0.0",
        "Website": "https://github.com/luquitas45/luquitas45.dotfiles"
    }
}
JSON

cat > "$OUT/metadata.desktop" <<'DESKTOP'
[Desktop Entry]
Name=Gorgoroth
Comment=Gorgoroth: recolored from "Monochrome" by Patrik Wyde.
X-KDE-PluginInfo-Author=Patrik Wyde
X-KDE-PluginInfo-Category=
X-KDE-PluginInfo-Depends=
X-KDE-PluginInfo-Email=patrik@wyde.se
X-KDE-PluginInfo-EnabledByDefault=true
X-KDE-PluginInfo-License=GPLv3
X-KDE-PluginInfo-Name=Gorgoroth
X-KDE-PluginInfo-Version=1.0.0
X-KDE-PluginInfo-Website=https://github.com/luquitas45/luquitas45.dotfiles
DESKTOP

echo "generated: kde/aurorae/Gorgoroth"
echo ""
echo "Done. Run kde/aurorae/verify.sh to check the result."
