format_context() {
  local ctx=$1
  local result=""
  local name namespace rest

  while [[ "$ctx" =~ '^vcluster_([^_]+)_([^_]+)_(.+)$' ]]; do
    name=$match[1]
    namespace=$match[2]
    rest=$match[3]

    result=" $(style "⟨v:" color "${prompt_colors[vcluster]}")$(style "${name}${result}" color "${prompt_colors[white_2]}")$(style "⟩" color "${prompt_colors[vcluster]}")"
    ctx=$rest
  done

  if [[ "$ctx" == kind-* ]]; then
    result=" $(style "⟨kind:" color "${prompt_colors[kind]}")$(style "${ctx#kind-}${result}" color "${prompt_colors[white_2]}")$(style "⟩" color "${prompt_colors[kind]}")"
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
