export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache

export EDITOR=vim

# for compatibility
# shell tools should know they're running in tmux, now directly in the terminal
if [[ -n "$TMUX" ]]; then
  export TERM=tmux-256color
fi

typeset -U path

path=("/usr/local/sbin" "/usr/local/bin" $path "${HOME}/.local/bin")

if [[ -x /opt/homebrew/bin ]]; then
    path=("/opt/homebrew/bin" "/opt/homebrew/opt/coreutils/libexec/gnubin" "/opt/homebrew/opt/findutils/libexec/gnubin" $path)
fi
