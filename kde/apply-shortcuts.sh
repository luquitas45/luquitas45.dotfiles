#!/usr/bin/env bash
# Apply the repo-owned global shortcuts that live in ~/.config/kglobalshortcutsrc
# but are not covered by apply-desktops.sh (idempotent, verified by readback).
#
# This is the reproducible alternative to versioning the whole kglobalshortcutsrc
# file (machine-specific, rewritten by KDE on use -> constant repo churn). State
# is read live from KGlobalAccel and verified; the script exits non-zero if the
# active binding does not match.
#
# Currently bound (Qt keys):
#   Meta+D (268435524) -> Yakuake toggle (yakuake/toggle-window-state). KDE's
#       default binds Meta+D to "Show Desktop", so that action is freed first.
#   Meta+H (268435528) -> the glow helper (net.local.kitty.desktop/_launch).
#
# Desktops (Meta+Z / Meta+X) live in apply-desktops.sh.
#
# Usage: bash kde/apply-shortcuts.sh
set -euo pipefail

for cmd in qdbus6 busctl; do
  if ! command -v "$cmd" >/dev/null 2>&1; then
    echo "ERROR: $cmd not found (a live Plasma 6 session is required)" >&2
    exit 1
  fi
done

META_H=268435528   # 0x10000000 | Qt::Key_H (0x48)
META_D=268435524   # 0x10000000 | Qt::Key_D (0x44)

YAKUAKE_COMP="yakuake"
YAKUAKE_ACTION="toggle-window-state"
YAKUAKE_NAME="Yakuake"
GLOW_COMPONENT="net.local.kitty.desktop"
GLOW_ACTION="_launch"
GLOW_NAME="Abrir hoja de atajos"

# Active (first) keys of an action, e.g. "[Argument: ai {268435524}]" or empty.
active_keys() { # componentPath action
  qdbus6 --literal org.kde.kglobalaccel "/component/$1" \
    org.kde.kglobalaccel.Component.allShortcutInfos \
    | tr ',' '\n' | grep -A9 "\"$2\"" \
    | grep -m1 -oE '\[Argument: ai \{[^}]*\}\]' || true
}

# --- 1) Glow: Meta+H on the net.local.kitty.desktop command shortcut ----------
# Register the component/action if it is not already there, then bind. doRegister
# is idempotent and makes a fresh machine register the same component.
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  doRegister "as" 4 "$GLOW_COMPONENT" "$GLOW_ACTION" "$GLOW_NAME" "$GLOW_NAME" >/dev/null
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  setForeignShortcut "asai" 4 "$GLOW_COMPONENT" "$GLOW_ACTION" "$GLOW_NAME" "$GLOW_NAME" 1 "$META_H" >/dev/null

# --- 2) Yakuake: Meta+D on its toggle; free "Show Desktop" first -------------
# Yakuake registers toggle-window-state only while it runs. Start it if needed
# and wait for the KGlobalAccel component to appear (up to ~10 s).
component_up() { qdbus6 org.kde.kglobalaccel 2>/dev/null | tr ' ' '\n' | grep -q "^/component/$YAKUAKE_COMP$"; }
if ! component_up; then
  echo "yakuake not running; starting it to register the toggle shortcut..."
  setsid yakuake >/dev/null 2>&1 &
  for _ in $(seq 1 20); do
    component_up && break
    sleep 0.5
  done
fi
if ! component_up; then
  echo "ERROR: Yakuake toggle never registered (check: qdbus6 org.kde.kglobalaccel)" >&2
  exit 1
fi
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  setForeignShortcut "asai" 4 "kwin" "Show Desktop" "KWin" "Show Desktop" 0 >/dev/null
busctl --user call org.kde.kglobalaccel /kglobalaccel org.kde.KGlobalAccel \
  setForeignShortcut "asai" 4 "$YAKUAKE_COMP" "$YAKUAKE_ACTION" "$YAKUAKE_NAME" "$YAKUAKE_NAME" 1 "$META_D" >/dev/null

# --- Verification: active (first) key arrays must hold exactly what we set ----
fail=0
check_active() { # componentPath action key label
  if active_keys "$1" "$2" | grep -q "{$3}"; then
    echo "verified: $4 -> $3"
  else
    echo "ERROR: $4 is not bound to $3" >&2
    fail=1
  fi
}
check_free() { # componentPath action key label
  if active_keys "$1" "$2" | grep -q "{$3}"; then
    echo "ERROR: $4 is still bound to $3" >&2
    fail=1
  else
    echo "verified: $4 is free of $3"
  fi
}

check_active "net_local_kitty_desktop" "$GLOW_ACTION" "$META_H" "Glow (Meta+H)"
check_active "$YAKUAKE_COMP" "$YAKUAKE_ACTION" "$META_D" "Yakuake toggle (Meta+D)"
check_free "kwin" "Show Desktop" "$META_D" "Show Desktop"

if [ "$fail" -ne 0 ]; then
  echo "ERROR: shortcut verification failed; inspect kglobalshortcutsrc" >&2
  exit 1
fi

echo ""
echo "Done. Repo global shortcuts are up to date."