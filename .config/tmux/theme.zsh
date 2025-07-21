#!/usr/bin/env zsh
# === Status bar
tmux set -g status-style "bg=${prompt_colors[black_0]}"

tmux set -g status-right "#[fg=${prompt_colors[white_1]}] %m/%d %H#[blink]:#[noblink]%M "

# === Window status formatting
tmux setw -g window-status-format          " #[fg=${prompt_colors[bg]}]#I #W "
tmux setw -g window-status-current-format  " #I #[nobold]#W "

tmux setw -g window-status-style           "fg=${prompt_colors[bg]},bg=${prompt_colors[black_2]}"
tmux setw -g window-status-current-style   "fg=${prompt_colors[bg]},bg=${prompt_colors[yellow_1]},bold"

# === Pane border styling
tmux set -g pane-active-border-style "fg=${prompt_colors[yellow_1]}"
tmux set -g pane-border-style        "fg=${prompt_colors[black_2]}"
