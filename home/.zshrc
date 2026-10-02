# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source /usr/share/cachyos-zsh-config/cachyos-config.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="$HOME/.local/bin:$PATH"

# zoxide: salto rapido a directorios (z)
eval "$(zoxide init zsh)"

# yazi: entrar y al salir, cd al directorio donde quedaste
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# ── Pulido zsh ──
DISABLE_AUTO_UPDATE="true"
setopt EXTENDED_HISTORY INC_APPEND_HISTORY
HISTSIZE=100000
SAVEHIST=100000
setopt NO_BEEP
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#505050"
export EDITOR=nvim
alias v="nvim"

# ── vi-mode ── (reactivado 10-oct: al final sí gustaba)
bindkey -v
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
bindkey -M vicmd k history-substring-search-up
bindkey -M vicmd j history-substring-search-down

# ── Cursor: restaurar barra (beam) al volver al prompt ──
# nvim sale dejando el bloque (DECSCUSR no se restaura solo):
# cada prompt nuevo vuelve a la barrita como en insert.
autoload -Uz add-zsh-hook
add-zsh-hook precmd _restore_beam
_restore_beam() { printf '\e[6 q' }

