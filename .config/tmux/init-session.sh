#!/bin/bash
# tmux session initialization entrypoint

SCRIPT_DIR="${HOME}/.config/tmux/sessions"

# Source all session definition scripts
for script in "$SCRIPT_DIR"/*.sh; do
  [ -f "$script" ] && source "$script"
done
