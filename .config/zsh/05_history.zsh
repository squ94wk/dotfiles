# History
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_verify
setopt inc_append_history
setopt share_history
HISTSIZE=100000
HISTFILE="${XDG_CACHE_HOME}/zsh/history"
mkdir -p "$(dirname ${HISTFILE})"
SAVEHIST=100000

