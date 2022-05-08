function git_prompt_info() {
  function print_pretty_ref() {
    local ref
    ref=$(command git "${@}" symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git "${@}" rev-parse --short HEAD 2> /dev/null) || return 0
    prompt_bold "${ref#refs/heads/}"
  }

  if [[ "${HOME}" == "${PWD}" ]]; then
    printf "%s" "dotfiles:"
    print_pretty_ref "dot"
  else
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) = "false" ]]; then
      return 0
    fi
    print_pretty_ref
  fi
}

ZSH_PROMPT_COLOR_GIT=246

prompt_add '$(prompt_color ${ZSH_PROMPT_COLOR_GIT} "$(git_prompt_info)")'

