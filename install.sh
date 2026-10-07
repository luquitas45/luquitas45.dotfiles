#!/usr/bin/env bash
# dotfiles — create symlinks from this repo into $HOME.
# Idempotent and safe: never overwrites a real file (errors out with
# instructions instead). Re-runnable.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# repo-relative source | absolute destination
LINKS=(
  "home/.zshrc|$HOME/.zshrc"
  "home/.p10k.zsh|$HOME/.p10k.zsh"
  "config/tmux/tmux.conf|$HOME/.config/tmux/tmux.conf"
  "config/kitty/kitty.conf|$HOME/.config/kitty/kitty.conf"
  "config/kitty/black-metal-gorgoroth.conf|$HOME/.config/kitty/black-metal-gorgoroth.conf"
  "config/yazi/theme.toml|$HOME/.config/yazi/theme.toml"
  "pi/agent/themes/gorgoroth.json|$HOME/.pi/agent/themes/gorgoroth.json"
  "kde/net.local.kitty.desktop|$HOME/.local/share/applications/net.local.kitty.desktop"
  "plasma/desktoptheme/gorgoroth|$HOME/.local/share/plasma/desktoptheme/gorgoroth"
  "plasma/colorschemes/Gorgoroth.colors|$HOME/.local/share/color-schemes/Gorgoroth.colors"
  "kde/plasmoids/io.github.daydve.fancytasksng|$HOME/.local/share/plasma/plasmoids/io.github.daydve.fancytasksng"
  "plasma/look-and-feel/org.lucas.gorgoroth|$HOME/.local/share/plasma/look-and-feel/org.lucas.gorgoroth"
  "kde/aurorae/upstream-monochrome/Monochrome|$HOME/.local/share/aurorae/themes/Monochrome"
  "kde/aurorae/upstream-monochrome/MonochromeBlur|$HOME/.local/share/aurorae/themes/MonochromeBlur"
  "kde/kvantum/upstream-monochrome/Monochrome|$HOME/.config/Kvantum/Monochrome"
  "kde/kvantum/upstream-monochrome/MonochromeBlur|$HOME/.config/Kvantum/MonochromeBlur"
  "kde/kvantum/upstream-monochrome/MonochromeSolid|$HOME/.config/Kvantum/MonochromeSolid"
  "kde/kvantum/kvantum.kvconfig|$HOME/.config/Kvantum/kvantum.kvconfig"
  "kde/kvantum/Gorgoroth|$HOME/.config/Kvantum/Gorgoroth"
  "kde/kvantum/GorgorothBlur|$HOME/.config/Kvantum/GorgorothBlur"
  "kde/kvantum/GorgorothSolid|$HOME/.config/Kvantum/GorgorothSolid"
  "atajos|$HOME/Documentos/atajos"
  "curso-js/vault|$HOME/alejandria/js-curso-jonmircha"
)

# nvim is linked as a whole directory (its content grows)
NVIM_SRC="$DOTFILES_DIR/config/nvim"
NVIM_DST="$HOME/.config/nvim"

link_file() {
  local src="$1" dst="$2"
  if [ -L "$dst" ]; then
    local current
    current="$(readlink "$dst")"
    if [ "$current" = "$src" ]; then
      echo "skip (already linked): $dst"
      return
    fi
    echo "ERROR: $dst is a symlink to $current (not this repo)."
    exit 1
  fi
  if [ -e "$dst" ]; then
    echo "ERROR: $dst exists as a real file. Back it up first, e.g.:"
    echo "  mv '$dst' '$dst.orig'"
    exit 1
  fi
  mkdir -p "$(dirname "$dst")"
  ln -s "$src" "$dst"
  echo "linked: $dst"
}

for pair in "${LINKS[@]}"; do
  src="${pair%%|*}"
  dst="${pair##*|}"
  link_file "$DOTFILES_DIR/$src" "$dst"
done

link_file "$NVIM_SRC" "$NVIM_DST"

echo ""
echo "All links ready. Reload your shells/configs to pick them up."
echo ""
echo "Plasma session settings (panel translucency, kwin blur, accent,"
echo "fancytasks applet, theme/scheme) are applied by:"
echo "  bash kde/apply-gorgoroth.sh"
echo "Run it after adding the panel/widgets, then log out/in."
echo "Note: kde/net.local.kitty.desktop embeds the absolute home path of"
echo "    'lucas' — adjust that file if this repo moves to another user."