# Layout for the fallback "default" session, and the reference for writing your own.
#
# tmux_start walks sessions/[0-9]*_*.sh in order and attaches to the first session
# no other terminal has claimed. The number orders that walk, the rest of the
# filename is the session name: 10_work.sh -> session "work". This file sorts last,
# so a terminal opened once every other session is taken lands in "default".
#
# A layout file is sourced only when its session is created, with $1 set to the
# session name. It can assume a fresh session with a single window 0, so it needs
# no has-session or window-exists guards, and it neither creates nor attaches the
# session -- tmux_session does both.
#
#   # sessions/10_work.sh
#   tmux rename-window -t "$1:0" scratch
#   tmux new-window -t "$1:" -n api -c "$HOME/git/api"
#   tmux new-window -t "$1:" -n web -c "$HOME/git/web"
#   tmux select-window -t "$1:scratch"
#
# Layout files are gitignored as machine-local drop-ins; only this one is tracked.

tmux rename-window -t "$1:0" scratch
