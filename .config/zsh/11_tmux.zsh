tmux_session() {
  local session="$1"
  if [[ -z "$session" ]]; then
    echo "Usage: tmux_session <name>"
    return 1
  fi

  if ! tmux has-session -t "$session" 2>/dev/null; then
    tmux new-session -d -s "$session"

    local layout=("${XDG_CONFIG_HOME}"/tmux/sessions/[0-9]*_"${session}".sh(N))
    [[ -n "$layout" ]] && source "$layout[1]" "$session"
  fi

  # leave sessions another terminal is already attached to alone
  if [[ -n "$(tmux list-clients -t "$session" 2>/dev/null)" ]]; then
    return 1
  fi

  if [[ -n "$TMUX" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach -t "$session"
  fi
}

tmux_start() {
  local config name
  for config in "${XDG_CONFIG_HOME}"/tmux/sessions/[0-9]*_*.sh(N); do
    name="${${config:t:r}#*_}"
    tmux_session "$name" && break
  done
}

# Outside tmux: join or create the next free session, falling through to a plain
# shell once every session is taken. Inside tmux: apply the theme from here, where
# prompt_colors is in scope (theme.zsh under tmux run-shell has no shell vars).
if [[ -z "$TMUX" ]]; then
  tmux_start && exit
else
  source "${XDG_CONFIG_HOME}/tmux/theme.zsh"
fi
