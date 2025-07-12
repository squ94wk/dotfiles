function kube_prompt_info() {
  local current_context
  if ! current_context=$(kubectl config current-context 2>/dev/null); then
    return
  fi

  if printf '%s\n' "$current_context" | grep -q '^vcluster_[^_]\+_[^_]\+_[^_]\+$'; then
    IFS=_ read -r _ name namespace host <<< "$current_context"
    printf '%s/%s\n' "$host" "$name"
  else
    printf '%s\n' "$current_context"
  fi
}

prompt_funcs+=(kube_prompt_info)
