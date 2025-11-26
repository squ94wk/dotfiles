# tmux session initialization

# Always source session definitions to make functions available
TMUX_SESSION_DEFS_ONLY=1 source "${HOME}/.config/tmux/init-session.sh"

tmux_init_sessions() {
  source "${HOME}/.config/tmux/init-session.sh"
}

if [[ -n "$TMUX" ]]; then
  if ! tmux show-environment -g TMUX_SESSIONS_INITIALIZED &>/dev/null; then
    echo -n "Initialize tmux session windows? (y/n) "
    read -q && {
      echo
      tmux set-environment -g TMUX_SESSIONS_INITIALIZED 1
      tmux_init_sessions
    }
    echo
  fi
fi
