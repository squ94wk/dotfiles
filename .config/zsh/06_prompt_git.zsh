# Git prompt segment

typeset -g PROMPT_GIT=""
typeset -gA PROMPT_GIT_STATE

# Define worker function - takes directory as argument
_prompt_git_job() {
  local dir=$1
  cd "$dir" || return 1

  git rev-parse --is-inside-work-tree &>/dev/null || return 1

  local result=""

  # Show "dotfiles:" in home directory
  if [[ "${dir}" == "${HOME}" ]]; then
    result+=" $(style "dotfiles:" color "${prompt_colors[white_1]}")"
  fi

  # Get branch name
  local ref
  ref=$(git symbolic-ref HEAD 2>/dev/null) || \
  ref=$(git rev-parse --short HEAD 2>/dev/null) || return 1
  result+="$(style "${ref#refs/heads/}" color "${prompt_colors[white_1]}" bold)"

  # Check for changes
  if git status | grep -E '^[MDAR]' &>/dev/null; then
    result+="+"
  fi

  print -r -- "$result"
}

# Callback - fires when job completes
_prompt_git_cb() {
  local job=$1 rc=$2 output=$3

  [[ "$job" == "[async/eval]" ]] && return
  [[ -n "$DEBUG_PROMPT" ]] && echo "[GIT CALLBACK] rc=$rc output=[$output]" >&2

  local old_value="$PROMPT_GIT"
  if (( rc == 0 )) && [[ -n "$output" ]]; then
    PROMPT_GIT=" $output"
    PROMPT_GIT_STATE[time]=$EPOCHSECONDS
  else
    PROMPT_GIT=""
  fi

  # Only redraw if value changed
  [[ "$old_value" != "$PROMPT_GIT" ]] && [[ -o zle ]] && zle reset-prompt
}

# Start worker (called on precmd)
_prompt_git_start() {
  # Stop existing worker if any
  async_stop_worker prompt_git_w 2>/dev/null

  # Start fresh worker
  async_start_worker prompt_git_w -u
  async_register_callback prompt_git_w _prompt_git_cb
  PROMPT_WORKERS[git]=prompt_git_w
}

# Queue update if TTL expired
_prompt_git_queue() {
  local ttl=${PROMPT_GIT_STATE[time]:-0}
  (( EPOCHSECONDS - ttl < 2 )) && return

  [[ -n "$DEBUG_PROMPT" ]] && echo "[GIT QUEUE] Queuing job for $PWD" >&2
  async_job prompt_git_w _prompt_git_job "$PWD" 2>/dev/null
}

# Stop worker before command execution
_prompt_git_stop() {
  async_stop_worker prompt_git_w 2>/dev/null
}

# Clear cache on directory change
_prompt_git_chpwd() {
  PROMPT_GIT=""
  PROMPT_GIT_STATE[time]=0
}

# Hook into prompt lifecycle
add-zsh-hook precmd _prompt_git_start
add-zsh-hook preexec _prompt_git_stop
add-zsh-hook chpwd _prompt_git_chpwd
prompt_update_funcs+=(_prompt_git_queue)
