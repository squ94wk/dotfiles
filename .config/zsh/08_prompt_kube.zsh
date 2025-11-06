# Kubernetes context prompt segment

typeset -g PROMPT_KUBE=""
typeset -gA PROMPT_KUBE_STATE

# Define worker function - takes KUBECONFIG as argument
_prompt_kube_job() {
  local kubeconfig=$1
  [[ -n "$kubeconfig" ]] && export KUBECONFIG="$kubeconfig"

  local ctx
  ctx=$(kubectl config current-context 2>/dev/null) || return 1

  local result=""
  local name namespace rest

  # Parse vcluster contexts
  while [[ "$ctx" =~ '^(vcluster(-platform)?)_([^_]+)_([^_]+)_(.+)$' ]]; do
    method=$match[1]
    name=$match[3]
    namespace=$match[4]
    rest=$match[5]

    if [[ "$method" == "vcluster" ]]; then
      indicator="v"
    elif [[ "$method" == "vcluster-platform" ]]; then
      indicator="p"
    fi

    result=" $(style "⟨${indicator}:" color "${prompt_colors[vcluster]}")$(style "${name}${result}" color "${prompt_colors[white_2]}")$(style "⟩" color "${prompt_colors[vcluster]}")"
    ctx=$rest
  done

  # Format known context types
  if [[ "$ctx" == kind-* ]]; then
    result=" $(style "⟨kind:" color "${prompt_colors[kind]}")$(style "${ctx#kind-}${result}" color "${prompt_colors[white_2]}")$(style "⟩" color "${prompt_colors[kind]}")"
  elif [[ "$ctx" == "kubernetes-admin@kubernetes" ]]; then
    local api_server
    api_server="$(kubectl config view --context kubernetes-admin@kubernetes -o jsonpath='{.clusters[?(@.name=="kubernetes")].cluster.server}' 2>/dev/null | sed 's|https://||')"
    result=" $(style "⟨k:" color "${prompt_colors[kind]}")$(style "${api_server}${result}" color "${prompt_colors[white_2]}")$(style "⟩" color "${prompt_colors[kind]}")"
  else
    result=" ⟨${ctx}${result}⟩"
  fi

  print -r -- "${result#" "}"
}

# Callback - fires when job completes
_prompt_kube_cb() {
  local job=$1 rc=$2 output=$3

  [[ "$job" == "[async/eval]" ]] && return
  [[ -n "$DEBUG_PROMPT" ]] && echo "[KUBE CALLBACK] rc=$rc output=[$output]" >&2

  local old_value="$PROMPT_KUBE"
  if (( rc == 0 )) && [[ -n "$output" ]]; then
    PROMPT_KUBE=" $output"
    PROMPT_KUBE_STATE[time]=$EPOCHSECONDS
  else
    PROMPT_KUBE=""
  fi

  # Only redraw if value changed
  [[ "$old_value" != "$PROMPT_KUBE" ]] && [[ -o zle ]] && zle reset-prompt
}

# Start worker (called on precmd)
_prompt_kube_start() {
  # Stop existing worker if any
  async_stop_worker prompt_kube_w 2>/dev/null

  # Start fresh worker
  async_start_worker prompt_kube_w -u
  async_register_callback prompt_kube_w _prompt_kube_cb
  PROMPT_WORKERS[kube]=prompt_kube_w
}

# Queue update if TTL expired
_prompt_kube_queue() {
  local ttl=${PROMPT_KUBE_STATE[time]:-0}
  (( EPOCHSECONDS - ttl < 5 )) && return

  [[ -n "$DEBUG_PROMPT" ]] && echo "[KUBE QUEUE] Queuing job" >&2
  async_job prompt_kube_w _prompt_kube_job "$KUBECONFIG" 2>/dev/null
}

# Stop worker before command execution
_prompt_kube_stop() {
  async_stop_worker prompt_kube_w 2>/dev/null
}

# Hook into prompt lifecycle
add-zsh-hook precmd _prompt_kube_start
add-zsh-hook preexec _prompt_kube_stop
prompt_update_funcs+=(_prompt_kube_queue)
