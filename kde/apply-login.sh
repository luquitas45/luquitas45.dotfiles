#!/usr/bin/env bash
# Apply the repo's Gorgoroth look to the Plasma Login Manager (plasmalogin) screen.
#
# The login screen is its own surface: the greeter runs as the `plasmalogin`
# user with its own configuration, and it cannot traverse the user's home
# (mode 700), so every asset it reads must be world-readable under /usr.
#
# Requires root (writes /etc, /usr and /var/lib/plasmalogin): run with sudo.
# Idempotent, verified by readback. Takes effect on the next login or reboot;
# do NOT restart plasmalogin.service (it kills the running session).
#
# Usage: sudo bash kde/apply-login.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

GREETER_USER=plasmalogin
GREETER_HOME=/var/lib/plasmalogin
GREETER_CONFIG="$GREETER_HOME/.config"
PLASMALOGIN_CONF=/etc/plasmalogin.conf

WALLPAPER_SRC="$REPO_DIR/plasma/wallpapers/gorgoroth.png"
WALLPAPER_DST=/usr/local/share/wallpapers/gorgoroth.png
COLORSCHEME_SRC="$REPO_DIR/plasma/colorschemes/Gorgoroth.colors"
COLORSCHEME_DST=/usr/share/color-schemes/Gorgoroth.colors
THEME_SRC="$REPO_DIR/plasma/desktoptheme/gorgoroth"
THEME_DST=/usr/share/plasma/desktoptheme/gorgoroth

STAMP="$(date +%Y%m%d-%H%M%S)"

log() { printf '%s\n' "$*"; }
die() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

# -- preflight ---------------------------------------------------------------
[ "$(id -u)" -eq 0 ] || die "needs root (writes /etc, /usr and $GREETER_HOME). Run: sudo bash kde/apply-login.sh"
command -v kwriteconfig6 >/dev/null 2>&1 || die "kwriteconfig6 not found (Plasma 6 required)"
id -u "$GREETER_USER" >/dev/null 2>&1 || die "user '$GREETER_USER' not found: is Plasma Login Manager installed?"
[ -d "$GREETER_HOME" ] || die "$GREETER_HOME not found"
for f in "$WALLPAPER_SRC" "$COLORSCHEME_SRC" "$THEME_SRC"; do
  [ -e "$f" ] || die "missing repo asset: $f"
done

log "== Gorgoroth: apply login screen look =="

# -- wallpaper ---------------------------------------------------------------
log "-- wallpaper"
install -Dm644 "$WALLPAPER_SRC" "$WALLPAPER_DST"
if [ -f "$PLASMALOGIN_CONF" ]; then
  cp -a "$PLASMALOGIN_CONF" "$PLASMALOGIN_CONF.bak.$STAMP"
fi
kwriteconfig6 --file "$PLASMALOGIN_CONF" \
  --group Greeter --key WallpaperPluginId org.kde.image
# Plasma addresses image wallpapers by absolute path (file://<abs path>).
kwriteconfig6 --file "$PLASMALOGIN_CONF" \
  --group Greeter --group Wallpaper --group org.kde.image --group General \
  --key Image "file://$WALLPAPER_DST"

# -- colors + plasma style ---------------------------------------------------
log "-- colors + plasma style"
install -Dm644 "$COLORSCHEME_SRC" "$COLORSCHEME_DST"
rm -rf "$THEME_DST"
cp -a "$THEME_SRC" "$THEME_DST"
chown -R root:root "$THEME_DST"

mkdir -p "$GREETER_CONFIG"
if [ -f "$GREETER_CONFIG/kdeglobals" ]; then
  cp -a "$GREETER_CONFIG/kdeglobals" "$GREETER_CONFIG/kdeglobals.bak.$STAMP"
fi
# The greeter's kdeglobals uses exactly the same groups as the .colors file.
cp "$COLORSCHEME_SRC" "$GREETER_CONFIG/kdeglobals"
kwriteconfig6 --file "$GREETER_CONFIG/kdeglobals" \
  --group General --key accentColor "#c1c1c1"
kwriteconfig6 --file "$GREETER_CONFIG/kdeglobals" \
  --group General --key accentColorFromWallpaper false
kwriteconfig6 --file "$GREETER_CONFIG/kdeglobals" \
  --group Icons --key Theme Papirus-Dark

if [ -f "$GREETER_CONFIG/plasmarc" ]; then
  cp -a "$GREETER_CONFIG/plasmarc" "$GREETER_CONFIG/plasmarc.bak.$STAMP"
fi
kwriteconfig6 --file "$GREETER_CONFIG/plasmarc" --group Theme --key name gorgoroth

chown "$GREETER_USER:$GREETER_USER" "$GREETER_CONFIG/kdeglobals" "$GREETER_CONFIG/plasmarc"
chmod 600 "$GREETER_CONFIG/kdeglobals" "$GREETER_CONFIG/plasmarc"

# -- readback ----------------------------------------------------------------
log "-- verify"
ok=1
check() { # label expected actual
  if [ "$2" = "$3" ]; then
    log "   ok   $1 = $3"
  else
    log "   FAIL $1: expected '$2', got '$3'"
    ok=0
  fi
}
check "plasmalogin.conf Image" "file://$WALLPAPER_DST" \
  "$(kreadconfig6 --file "$PLASMALOGIN_CONF" \
      --group Greeter --group Wallpaper --group org.kde.image --group General --key Image)"
check "greeter ColorScheme" "Gorgoroth" \
  "$(kreadconfig6 --file "$GREETER_CONFIG/kdeglobals" --group General --key ColorScheme)"
check "greeter accentColor" "#c1c1c1" \
  "$(kreadconfig6 --file "$GREETER_CONFIG/kdeglobals" --group General --key accentColor)"
check "greeter plasmarc" "gorgoroth" \
  "$(kreadconfig6 --file "$GREETER_CONFIG/plasmarc" --group Theme --key name)"

if runuser -u "$GREETER_USER" -- test -r "$WALLPAPER_DST" 2>/dev/null; then
  log "   ok   $GREETER_USER can read the wallpaper"
else
  log "   FAIL $GREETER_USER cannot read $WALLPAPER_DST"
  ok=0
fi

[ "$ok" -eq 1 ] || die "readback failed"
log "done. Applies on the next login/reboot (do not restart plasmalogin.service)."
