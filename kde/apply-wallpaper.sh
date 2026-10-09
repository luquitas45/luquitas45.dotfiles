#!/usr/bin/env bash
# Apply the repo-owned desktop wallpaper (idempotent, verified by readback).
#
# The image lives in the repo (plasma/wallpapers/gorgoroth.png) and install.sh
# links it to a stable $HOME path, so the same command works on any machine.
# Plasma addresses image wallpapers by absolute path, so the wallpaper is
# addressed through $HOME and never a hardcoded /home/<user>.
#
# Applies to the current activity's desktop containment. Run install.sh first:
# without the link the wallpaper path does not exist.
#
# Usage: bash kde/apply-wallpaper.sh
set -euo pipefail

WALLPAPER="$HOME/.local/share/wallpapers/gorgoroth.png"
APPLETSRC="$HOME/.config/plasma-org.kde.plasma.desktop-appletsrc"

echo "== Gorgoroth: apply desktop wallpaper =="

if ! command -v plasma-apply-wallpaperimage >/dev/null 2>&1; then
  echo "ERROR: plasma-apply-wallpaperimage not found (a live Plasma 6 session is required)" >&2
  exit 1
fi

if [ ! -e "$WALLPAPER" ]; then
  echo "ERROR: $WALLPAPER not found. Run install.sh first (missing symlink?)" >&2
  exit 1
fi

plasma-apply-wallpaperimage "$WALLPAPER"
echo "wallpaper applied: $WALLPAPER"

# Read the live config back: Plasma stores the image as file://<absolute path>.
if [ -f "$APPLETSRC" ] && grep -qF "Image=file://$WALLPAPER" "$APPLETSRC"; then
  echo "verified: containment Image points at the repo wallpaper"
else
  echo "WARN: could not confirm the Image entry in $APPLETSRC" >&2
  exit 1
fi
