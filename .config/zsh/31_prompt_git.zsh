function git_prompt_info() {
  if [[ "${PWD}" == "${HOME}" ]]; then
    printf "%s" "dotfiles:"
  fi

  if ! $git rev-parse --is-inside-work-tree &> /dev/null; then
    return 0
  fi

  local ref
  ref=$($git symbolic-ref HEAD 2> /dev/null) || \
  ref=$($git rev-parse --short HEAD 2> /dev/null) || return 0
  prompt_bold "${ref#refs/heads/}"

  if $git s | grep -E '^[MDAR]' &>/dev/null; then
      printf "%s" "+"
  fi
}

ZSH_PROMPT_COLOR_GIT=246

prompt_add '$(prompt_color ${ZSH_PROMPT_COLOR_GIT} "$(git_prompt_info)")'

