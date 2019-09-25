ZSH_CUSTOM="${HOME}/.zsh_custom.d"
source "${ZSH_CUSTOM}/env.zsh"
source "${ZSH_CUSTOM}/patches.zsh"
if [[ -s "${ZSH_CUSTOM}/local.zsh" ]]; then source "${ZSH_CUSTOM}/local.zsh"; fi

export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="custom"

# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

plugins=(
  git-flow
  tmux
  docker
  brew
  history
  node
  npm
  kubectl
  zsh-autosuggestions
  zsh-syntax-highlighting
  zsh-completions
)

source $ZSH/oh-my-zsh.sh

autoload -Uz compinit && compinit 

export TERM=xterm-256color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=242'

zstyle ':completion:*' menu select

bindkey "[D" backward-word
bindkey "[C" forward-word
# bindkey "^[a" beginning-of-line
# bindkey "^[e" end-of-line
bindkey "^[[D" beginning-of-line
bindkey "^[[C" end-of-line


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

