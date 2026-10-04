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

set_key() { kwriteconfig6 --file plasma-org.kde.plasma.desktop-appletsrc --group "$GROUP" --key "$1" "$2"; }

set_key disableButtonInactiveSvg true     # no backgrounds on inactive buttons
set_key groupingStrategy 0
set_key indicatorActiveSize 4
set_key indicatorAlignment 2             # cross-axis alignment: inner
set_key indicatorDimInactive true
set_key indicatorOverride true
set_key indicatorProgressStyle 0
set_key indicatorResize false
set_key indicatorSize 2
set_key indicatorsEnabled 1
set_key indicatorLocation 1              # 0=Top 1=Bottom 2=Left 3=Right
set_key taskHoverEffect false
set_key taskHoverEffectStyle 1
set_key useBorders false
set_key launchers "applications:systemsettings.desktop,preferred://filemanager"

echo "Done. Restart plasmashell (or log out/in) to apply:"
echo "  plasmashell --replace &"