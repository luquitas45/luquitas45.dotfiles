#!/usr/bin/env bash
# dotfiles — create symlinks from this repo into $HOME.
#
# Two-pass and all-or-nothing: the whole plan is classified BEFORE anything is
# created. If any destination is occupied by a real file or a foreign symlink,
# the script prints every conflict with the exact command to resolve it and
# exits without creating a single link — $HOME is never left half-linked.
#
# Idempotent: re-running only reports skips and removes a stale autostart link.
# It never overwrites a real file.
#
# Usage:
#   bash install.sh          create the missing links
#   bash install.sh --check  only print the plan (exit 1 if there are conflicts)
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK_ONLY=0
for arg in "$@"; do
  case "$arg" in
    --check) CHECK_ONLY=1 ;;
    -h|--help) sed -n '2,12p' "${BASH_SOURCE[0]}"; exit 0 ;;
    *) echo "unknown argument: $arg (try --check)" >&2; exit 2 ;;
  esac
done

# repo-relative source | absolute destination
LINKS=(
  "home/.zshrc|$HOME/.zshrc"
  "home/.p10k.zsh|$HOME/.p10k.zsh"
  "config/tmux/tmux.conf|$HOME/.config/tmux/tmux.conf"
  "config/tmux/bin/session-uptime|$HOME/.local/bin/session-uptime"
  "config/kitty/kitty.conf|$HOME/.config/kitty/kitty.conf"
  "config/kitty/black-metal-gorgoroth.conf|$HOME/.config/kitty/black-metal-gorgoroth.conf"
  "config/yazi/theme.toml|$HOME/.config/yazi/theme.toml"
  "pi/agent/themes/gorgoroth.json|$HOME/.pi/agent/themes/gorgoroth.json"
  "kde/net.local.kitty.desktop|$HOME/.local/share/applications/net.local.kitty.desktop"
  "kde/net.local.kitty.dev.desktop|$HOME/.local/share/applications/net.local.kitty.dev.desktop"
  "kde/net.local.dev-desktop.desktop|$HOME/.local/share/applications/net.local.dev-desktop.desktop"
  "kde/dev-kitty.sh|$HOME/.local/bin/dev-kitty"
  "kde/dev-desktop.sh|$HOME/.local/bin/dev-desktop"
  "plasma/desktoptheme/gorgoroth|$HOME/.local/share/plasma/desktoptheme/gorgoroth"
  "plasma/colorschemes/Gorgoroth.colors|$HOME/.local/share/color-schemes/Gorgoroth.colors"
  "kde/plasmoids/io.github.daydve.fancytasksng|$HOME/.local/share/plasma/plasmoids/io.github.daydve.fancytasksng"
  "kde/kwinrulesrc|$HOME/.config/kwinrulesrc"
  "plasma/look-and-feel/org.lucas.gorgoroth|$HOME/.local/share/plasma/look-and-feel/org.lucas.gorgoroth"
  "kde/aurorae/upstream-monochrome/Monochrome|$HOME/.local/share/aurorae/themes/Monochrome"
  "kde/aurorae/upstream-monochrome/MonochromeBlur|$HOME/.local/share/aurorae/themes/MonochromeBlur"
  "kde/aurorae/Gorgoroth|$HOME/.local/share/aurorae/themes/Gorgoroth"
  "kde/kvantum/upstream-monochrome/Monochrome|$HOME/.config/Kvantum/Monochrome"
  "kde/kvantum/upstream-monochrome/MonochromeBlur|$HOME/.config/Kvantum/MonochromeBlur"
  "kde/kvantum/upstream-monochrome/MonochromeSolid|$HOME/.config/Kvantum/MonochromeSolid"
  "kde/kvantum/kvantum.kvconfig|$HOME/.config/Kvantum/kvantum.kvconfig"
  "kde/kvantum/Gorgoroth|$HOME/.config/Kvantum/Gorgoroth"
  "kde/kvantum/GorgorothBlur|$HOME/.config/Kvantum/GorgorothBlur"
  "kde/kvantum/GorgorothSolid|$HOME/.config/Kvantum/GorgorothSolid"
  "kde/yakuake/yakuakerc|$HOME/.config/yakuakerc"
  "kde/yakuake/skins/upstream-monochrome|$HOME/.local/share/yakuake/skins/monochrome"
  "kde/yakuake/skins/Gorgoroth|$HOME/.local/share/yakuake/skins/gorgoroth"
  "kde/konsole/Kitty.profile|$HOME/.local/share/konsole/Kitty.profile"
  "kde/konsole/colorschemes/KittyMonochrome.colorscheme|$HOME/.local/share/konsole/KittyMonochrome.colorscheme"
  "kde/konsole/colorschemes/Monochrome.colorscheme|$HOME/.local/share/konsole/Monochrome.colorscheme"
  "kde/konsole/colorschemes/Gorgoroth.colorscheme|$HOME/.local/share/konsole/Gorgoroth.colorscheme"
  "kde/autostart/org.kde.yakuake.desktop|$HOME/.config/autostart/org.kde.yakuake.desktop"
  "atajos|$HOME/Documentos/atajos"
  "curso-js/vault|$HOME/alejandria/js-curso-jonmircha"
)

# nvim is linked as a whole directory (its content grows)
NVIM_SRC="$DOTFILES_DIR/config/nvim"
NVIM_DST="$HOME/.config/nvim"

PLAN_SRC=()
PLAN_DST=()
PLAN_STATE=()

# classify src dst -> link | skip | conflict:<reason>
classify() {
  local src="$1" dst="$2"
  if [ ! -e "$src" ]; then
    echo "conflict:missing-source:$src"
    return
  fi
  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst")"
    if [ "$current" = "$src" ]; then
      echo "skip"
    else
      echo "conflict:symlink-to:$current"
    fi
    return
  fi
  if [ -e "$dst" ]; then
    if [ -d "$dst" ]; then echo "conflict:real-directory"; else echo "conflict:real-file"; fi
    return
  fi
  echo "link"
}

add_to_plan() {
  PLAN_SRC+=("$1")
  PLAN_DST+=("$2")
  PLAN_STATE+=("$(classify "$1" "$2")")
}

for pair in "${LINKS[@]}"; do
  add_to_plan "$DOTFILES_DIR/${pair%%|*}" "${pair##*|}"
done
add_to_plan "$NVIM_SRC" "$NVIM_DST"

CREATE=0; SKIP=0; CONFLICTS=0
for state in "${PLAN_STATE[@]}"; do
  case "$state" in
    link) CREATE=$((CREATE + 1)) ;;
    skip) SKIP=$((SKIP + 1)) ;;
    *)    CONFLICTS=$((CONFLICTS + 1)) ;;
  esac
done

echo "dotfiles -> $HOME"
echo "  ${#PLAN_DST[@]} destinations: $CREATE to create, $SKIP already linked, $CONFLICTS conflicts"

if [ "$CONFLICTS" -gt 0 ]; then
  echo ""
  echo "ERROR: $CONFLICTS destination(s) are not links from this repo. Nothing was created."
  echo ""
  for i in "${!PLAN_DST[@]}"; do
    case "${PLAN_STATE[$i]}" in
      conflict:*)
        echo "  ${PLAN_DST[$i]}"
        echo "      ${PLAN_STATE[$i]#conflict:}"
        echo "      fix: mv '${PLAN_DST[$i]}' '${PLAN_DST[$i]}.orig'"
        ;;
    esac
  done
  echo ""
  echo "Move those aside and re-run. This script never overwrites a real file."
  exit 1
fi

if [ "$CHECK_ONLY" = 1 ]; then
  echo ""
  echo "check only: nothing created."
  exit 0
fi

for i in "${!PLAN_DST[@]}"; do
  src="${PLAN_SRC[$i]}"
  dst="${PLAN_DST[$i]}"
  if [ "${PLAN_STATE[$i]}" = skip ]; then
    echo "skip (already linked): $dst"
  else
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "linked: $dst"
  fi
done

# Remove the stale autostart symlink that earlier installs created; the dev
# kitty is no longer autostarted, so login stays on the Principal desktop. Only
# touch a symlink whose target resolves inside this repo, so a real file or a
# foreign link is never deleted. Idempotent: gone is a no-op.
STALE_AUTOSTART="$HOME/.config/autostart/net.local.kitty.dev.desktop"
if [ -L "$STALE_AUTOSTART" ]; then
  stale_target="$(readlink -f "$STALE_AUTOSTART" 2>/dev/null || true)"
  case "$stale_target" in
    "$DOTFILES_DIR"/*)
      rm -f "$STALE_AUTOSTART"
      echo "removed stale autostart link: $STALE_AUTOSTART"
      ;;
  esac
fi

# Prerequisites for the Plasma session look: warn, never install.
MISSING=()
for tool in kwriteconfig6 qdbus6 plasma-apply-lookandfeel kvantummanager; do
  command -v "$tool" >/dev/null 2>&1 || MISSING+=("$tool")
done
if [ "${#MISSING[@]}" -gt 0 ]; then
  echo ""
  echo "WARN: missing tools for the Plasma session look: ${MISSING[*]}"
  echo "      install with: sudo pacman -S kvantum plasma-workspace"
fi

echo ""
echo "All links ready. Open a new shell (and a new tmux/kitty session) to pick them up."
echo "Next: bash kde/apply-gorgoroth.sh   (global theme + Kvantum + panel + blur, then relogin)"
echo "Docs: docs/install-cachyos.md"
