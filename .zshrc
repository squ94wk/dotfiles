ZSH="${HOME}/.zsh"
source "${ZSH}/env.zsh"
if [[ -s "${ZSH}/local.zsh" ]]; then source "${ZSH}/local.zsh"; fi
source "${ZSH}/prompt.zsh"
source "${ZSH}/dirs.zsh"
source "${ZSH}/smart_opts.zsh" # grep

# plugins
source "${ZSH}/plugins/vi-mode/zsh-vim-mode.plugin.zsh"
source "${ZSH}/plugins/autosuggestions/zsh-autosuggestions.zsh"
source "${ZSH}/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${ZSH}/plugins/completions/zsh-completions.plugin.zsh"

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_verify
setopt inc_append_history
setopt share_history
HISTSIZE=10000
HISTFILE="${HOME}/.zsh_history"
SAVEHIST=10000


autoload -Uz compinit
for dump in ~/.zcompdump(N.mh+24); do
    compinit
done
compinit -C

export TERM=xterm-256color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

zstyle ':completion:*' menu select

if [[ -n $IDEA_TERMINAL ]]; then
	bindkey "\e\eOD" backward-word
	bindkey "\e\eOC" forward-word
#	bindkey "^[a" beginning-of-line
#	bindkey "^[e" end-of-line
fi

ssh() {
  if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=)" = "tmux" ]; then
    tmux rename-window "$(echo $*)"
    command ssh "$@"
    tmux set-window-option automatic-rename "on" 1>/dev/null
  else
    command ssh "$@"
  fi
}

alias dotfiles='/usr/bin/git --git-dir=${HOME}/.dotfiles/ --work-tree=${HOME}'

