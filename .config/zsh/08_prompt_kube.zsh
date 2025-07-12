vcluster_color=202
kind_color=68
format_context() {
  local ctx=$1
  local result=""
  local name namespace rest

  while [[ "$ctx" =~ '^vcluster_([^_]+)_([^_]+)_(.+)$' ]]; do
    name=$match[1]
    namespace=$match[2]
    rest=$match[3]

    result=" $(prompt_color "$vcluster_color" "⟨v:")${name}${result}$(prompt_color "$vcluster_color" "⟩")"
    ctx=$rest
  done

  if [[ "$ctx" == kind-* ]]; then
    result=" $(prompt_color "$kind_color" "⟨kind:")${ctx#kind-}${result}$(prompt_color "$kind_color" "⟩")"
  fi

  print -r -- "${result}"
}


function kube_prompt_info() {
  local current_context
  if ! current_context=$(kubectl config current-context 2>/dev/null); then
    return
  fi

  PROMPT+=" $(format_context $current_context)"
}

prompt_funcs+=(kube_prompt_info)
