#!/usr/bin/env bash
# Apply the full Gorgoroth Plasma session look (idempotent).
# Covers everything that lives in ~/.config and is NOT a symlinked file:
#   - desktop theme name
#   - color scheme + accent color
#   - panel translucency
#   - KWin blur strength
#   - FancyTasks applet config (delegated to fancytasks-config.sh)
# Then applies colorscheme, reloads KWin and restarts plasmashell.
#
# Usage: bash kde/apply-gorgoroth.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPLETSRC="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
KWINRC="kwinrc"

echo "== Gorgoroth: apply session look =="

# 1) Desktop theme + color scheme + accent
kwriteconfig6 --file plasmarc      --group Theme   --key name gorgoroth
kwriteconfig6 --file kdeglobals    --group General --key ColorScheme Gorgoroth
kwriteconfig6 --file kdeglobals    --group General --key accentColor "#c1c1c1"
kwriteconfig6 --file kdeglobals    --group General --key accentColorFromWallpaper false
echo "theme/colorscheme/accent set"

# 2) Panel translucency (find the panel containment dynamically)
if [ -f "$APPLETSRC" ]; then
  PANEL="$(awk '
    /^\[Containments\]\[[0-9]+\]$/ { id=$0; gsub(/[^0-9]/,"",id) }
    /^plugin=org\.kde\.panel$/     { print id; exit }
  ' "$APPLETSRC")"
  if [ -n "${PANEL:-}" ]; then
    kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
      --group Containments --group "$PANEL" --group General --key opacity translucent
    echo "panel $PANEL -> opacity=translucent"
  else
    echo "WARN: no org.kde.panel containment found; add the panel first, then re-run"
  fi
else
  echo "WARN: $APPLETSRC not found (no panel yet?)"
fi

# 3) KWin blur strength (and make sure the effect is enabled)
kwriteconfig6 --file "$KWINRC" --group Plugins     --key blurEnabled true
kwriteconfig6 --file "$KWINRC" --group Effect-blur --key BlurStrength 6
kwriteconfig6 --file "$KWINRC" --group Effect-blur --key NoiseStrength 0
echo "kwin blur set"

# 4) FancyTasks applet config
if [ -f "$HERE/fancytasks-config.sh" ]; then
  bash "$HERE/fancytasks-config.sh" || echo "WARN: fancytasks-config.sh failed (widget not present?)"
fi

# 5) Apply what can be applied live
plasma-apply-colorscheme Gorgoroth >/dev/null 2>&1 || true
qdbus6 org.kde.KWin /KWin org.kde.KWin.reconfigure >/dev/null 2>&1 || true
echo "colorscheme + kwin reloaded"

# 6) Restart plasmashell (best effort; a relogin may still be needed for accent)
if command -v plasmashell >/dev/null 2>&1; then
  setsid plasmashell --replace >/dev/null 2>&1 &
  echo "plasmashell restart requested"
fi

echo ""
echo "Done. A logout/login is recommended so the accent/colors apply everywhere."
