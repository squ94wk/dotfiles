# don't print '(venv)' when in virtual env
export VIRTUAL_ENV_DISABLE_PROMPT=1

# Simple prompt mode
if [[ "$SIMPLE_PROMPT" == "1" ]]; then
    PROMPT='%~ %# '
    RPROMPT=''
    return 0
fi

# Enable prompt substitution for variable expansion
setopt promptsubst

# Global variables for prompt segments
typeset -g PROMPT_GIT=""
typeset -g PROMPT_KUBE=""

# Global state for async workers
typeset -gA PROMPT_LAST_UPDATE   # Last update time for each segment
typeset -g PROMPT_CLEANUP_NEEDED=0

function _is_tmux_pane_visible() {
  [[ -z "$TMUX" ]] && return 0
  [[ "$(tmux display-message -p '#{window_active}#{pane_active}')" == "11" ]]
}

# Initialize async system
async_init

# Track all workers for cleanup
typeset -gA PROMPT_WORKERS

# Auto-refresh prompt every 2 seconds and queue updates
TMOUT=2
TRAPALRM () {
    # Only run if ZLE is active
    [[ -o zle ]] || return

    # Segments can hook into this by adding functions to prompt_update_funcs
    for func in $prompt_update_funcs; do
      $func
    done

    # Redraw prompt unless in fzf
    if [[ ! "$WIDGET" =~ ^fzf_.*$ ]]; then
        zle reset-prompt
    fi
}

typeset -ga prompt_update_funcs

# Clean up on exit
zshexit() {
  for worker in ${PROMPT_WORKERS[@]}; do
    async_stop_worker "$worker" 2>/dev/null
  done
}

function prompt_bold() {
    printf "%%B%s%%b" "$@"
}
