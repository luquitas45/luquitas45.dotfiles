#!/usr/bin/env bash
# Apply the full Gorgoroth Plasma session look (idempotent).
#
# The global theme package carries the desktop theme, color scheme + accent,
# widget style, icons, cursor and window decoration. This script delegates that
# part to plasma-apply-lookandfeel and only writes what a look-and-feel package
# cannot set: panel translucency, KWin blur and the Kvantum theme selection.
# Then it reloads KWin and restarts plasmashell.
#
# Usage: bash kde/apply-gorgoroth.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APPLETSRC="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
KWINRC="kwinrc"
LOOKANDFEEL="org.lucas.gorgoroth"

echo "== Gorgoroth: apply session look =="

# 1) Global theme: theme, scheme + accent, widget style, icons, cursor, decoration
if plasma-apply-lookandfeel --list 2>/dev/null | grep -qE "^[[:space:]]*${LOOKANDFEEL}[[:space:]]*$"; then
  plasma-apply-lookandfeel -a "$LOOKANDFEEL"
  echo "global theme applied: $LOOKANDFEEL"
else
  echo "ERROR: $LOOKANDFEEL not found. Run install.sh first (missing symlink?)" >&2
  exit 1
fi

# 2) Kvantum theme selection (Kvantum reads its own config; install.sh links it
#    from kde/kvantum/kvantum.kvconfig, so this just makes Kvantum reload it)
if command -v kvantummanager >/dev/null 2>&1 && [ -d "$HOME/.config/Kvantum/GorgorothBlur" ]; then
  kvantummanager --set GorgorothBlur >/dev/null 2>&1 || echo "WARN: kvantummanager --set failed"
  echo "kvantum theme: GorgorothBlur"
else
  echo "WARN: Kvantum or the GorgorothBlur theme not found; skipping widget style"
fi

# 3) Panel translucency (find the panel containment dynamically)
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

# 4) KWin blur strength (and make sure the effect is enabled)
kwriteconfig6 --file "$KWINRC" --group Plugins     --key blurEnabled true
kwriteconfig6 --file "$KWINRC" --group Effect-blur --key BlurStrength 6
kwriteconfig6 --file "$KWINRC" --group Effect-blur --key NoiseStrength 0
echo "kwin blur set"

# 5) FancyTasks applet config (pinned launchers are user data: preserved)
if [ -f "$HERE/fancytasks-config.sh" ]; then
  bash "$HERE/fancytasks-config.sh" || echo "WARN: fancytasks-config.sh failed (widget not present?)"
fi

# 6) Reload what can be reloaded live
qdbus6 org.kde.KWin /KWin org.kde.KWin.reconfigure >/dev/null 2>&1 || true
echo "kwin reloaded"

# 7) Restart plasmashell (best effort; a relogin may still be needed for accent)
if command -v plasmashell >/dev/null 2>&1; then
  setsid plasmashell --replace >/dev/null 2>&1 &
  echo "plasmashell restart requested"
fi

echo ""
echo "Done. A logout/login is recommended so the accent/colors apply everywhere."
echo "SDDM login theme is root-owned and manual; see kde/README.md."
