#!/usr/bin/env bash
# Apply the Gorgoroth FancyTasks applet config to the running session.
# Idempotent: looks up the applet instance that hosts the FancyTasks plugin
# in the current plasma appletsrc and writes the keys with kwriteconfig6.
# Usage: bash kde/fancytasks-config.sh   (then restart plasmashell / logout)
set -euo pipefail

FILE="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"
[ -f "$FILE" ] || { echo "appletsrc not found: $FILE"; exit 1; }

# Find "containmentId appletId" for the FancyTasks plugin
read -r CONT APPLET <<< "$(awk '/^\[Containments\]\[[0-9]+\]\[Applets\]\[[0-9]+\]$/{ \
      id=$0; \
      if (match(id, /\[Containments\]\[[0-9]+\]\[Applets\]\[[0-9]+\]/)) {} } \
    /^plugin=io.github.daydve.fancytasksng/{ \
      split($0, p, "="); \
      gsub(/^\[Containments\]\[/, "", id); \
      gsub(/\]\[Applets\]\[/, " ", id); \
      gsub(/\]$/, "", id); \
      print id }' "$FILE" | head -1)"

if [ -z "${CONT:-}" ]; then
  echo "ERROR: FancyTasks (io.github.daydve.fancytasksng) not found in $FILE"
  echo "Add the widget to a panel first, then run this script again."
  exit 1
fi

GROUP="Containments][$CONT][Applets][$APPLET][Configuration][General"
echo "Applying FancyTasks config to containment $CONT, applet $APPLET"

# kwriteconfig6 needs the nested group as repeated --group flags
set_key() {
  kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
    --group Containments --group "$CONT" --group Applets --group "$APPLET" \
    --group Configuration --group General \
    --key "$1" "$2"
}

set_key disableButtonInactiveSvg false    # mostrar fondo tambien en inactivos
set_key disableButtonSvg false            # usar el SVG de fondo del tema
set_key buttonColorize true               # colorear el fondo de las apps abiertas
set_key buttonColorizeDominant false      # color fijo, no el dominante del icono
set_key buttonColorizeCustom "#222222"    # fondo de boton real de la paleta (Colors:Button)
set_key buttonColorizeInactive true       # mismo color para las inactivas
set_key groupingStrategy 0
set_key indicatorActiveSize 3
set_key indicatorAlignment 2             # cross-axis alignment: inner
set_key indicatorInactiveOpacity 60
set_key indicatorOverride true
set_key indicatorProgressStyle 0
set_key indicatorSize 2
set_key indicatorsEnabled 1
set_key indicatorLocation 1              # 0=Top 1=Bottom 2=Left 3=Right
set_key indicatorLength 12               # longitud del indicador (tu ajuste a mano)
set_key taskHoverEffect false
set_key taskHoverEffectStyle 1
set_key useBorders false

# User data, not theme: only seed launchers when the applet has none, so the
# pinned apps survive re-running this script.
if [ -z "$(kreadconfig6 --file plasma-org.kde.plasma.desktop-appletsrc \
        --group Containments --group "$CONT" --group Applets --group "$APPLET" \
        --group Configuration --group General --key launchers)" ]; then
  set_key launchers "applications:systemsettings.desktop,preferred://filemanager"
  echo "launchers: seeded with the defaults"
else
  echo "launchers: keeping the existing pinned list"
fi

set_key indicatorAccentColor false          # desactivar acento en el indicador
set_key indicatorDominantColor false
set_key indicatorCustomColor "#c1c1c1"      # indicador activo en claro (tmux)

echo "Done. Restart plasmashell (or log out/in) to apply:"
echo "  plasmashell --replace &"
