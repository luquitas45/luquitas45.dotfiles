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

# ── Gorgoroth: LS_COLORS + fzf ── (10-oct: paleta del tema, sync con yazi)
export LS_COLORS="no=\e[0m:fi=\e[38;2;193;193;193m:di=\e[38;2;136;136;136m:ln=\e[38;2;221;238;204m:ex=\e[38;2;170;170;170m:pi=\e[38;2;95;135;135m:so=\e[38;2;95;135;135m:bd=\e[38;2;136;136;136m:cd=\e[38;2;136;136;136m:or=\e[38;2;95;135;135m:mi=\e[38;2;95;135;135m:tw=\e[1;38;2;136;136;136m:ow=\e[38;2;95;135;135m:st=\e[1;38;2;136;136;136m:*.tar=\e[38;2;95;135;135m:*.tgz=\e[38;2;95;135;135m:*.gz=\e[38;2;95;135;135m:*.bz2=\e[38;2;95;135;135m:*.tbz=\e[38;2;95;135;135m:*.xz=\e[38;2;95;135;135m:*.7z=\e[38;2;95;135;135m:*.zip=\e[38;2;95;135;135m:*.rar=\e[38;2;95;135;135m:*.zst=\e[38;2;95;135;135m:*.iso=\e[38;2;95;135;135m:*.png=\e[38;2;155;141;127m:*.jpg=\e[38;2;155;141;127m:*.jpeg=\e[38;2;155;141;127m:*.gif=\e[38;2;155;141;127m:*.svg=\e[38;2;155;141;127m:*.webp=\e[38;2;155;141;127m:*.mp4=\e[38;2;221;238;204m:*.mkv=\e[38;2;221;238;204m:*.webm=\e[38;2;221;238;204m:*.mp3=\e[38;2;221;238;204m:*.flac=\e[38;2;221;238;204m:*.wav=\e[38;2;221;238;204m"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS
--color=fg:#c1c1c1,bg:#000000,hl:#9b8d7f,gutter:#000000
--color=fg+:#c1c1c1,bg+:#000000,hl+:#9b8d7f
--color=info:#505050,prompt:#9b8d7f,pointer:#c1c1c1
--color=marker:#999999,spinner:#999999,header:#999999"

