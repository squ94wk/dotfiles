format_context() {
  local ctx=$1
  local result=""
  local name namespace rest

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


function kube_prompt_info() {
  local current_context
  if ! current_context=$(kubectl config current-context 2>/dev/null); then
    return
  fi

  PROMPT+=" $(format_context $current_context)"
}

prompt_funcs+=(kube_prompt_info)
