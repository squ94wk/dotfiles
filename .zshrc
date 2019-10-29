# If you come from bash you might have to change your $PATH.
export PATH=/bin:/usr/bin:/usr/local/bin:/usr/local/sbin:${PATH}
export PATH=/usr/local/go/bin:${PATH}
export PATH=${HOME}/go/bin:${PATH}
export GOROOT=/usr/local/Cellar/go/1.12.7

export ZSH="${HOME}/.oh-my-zsh"


ZSH_THEME="custom"
ZSH_CUSTOM="${HOME}/.zsh_custom.d"
source "${ZSH_CUSTOM}"/patches.zsh

plugins=(
  git
  git-flow
  brew
  history
  node
  npm
  kubectl
)

source $ZSH/oh-my-zsh.sh

# Set CLICOLOR if you want Ansi Colors in iTerm2 
export CLICOLOR=1
export TERM=xterm-256color

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

