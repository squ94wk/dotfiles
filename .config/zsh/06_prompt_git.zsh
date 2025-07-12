function git_prompt_info() {
  PROMPT+=' '
  if [[ "${PWD}" == "${HOME}" ]]; then
    PROMPT+="dotfiles:"
  fi

  if ! git rev-parse --is-inside-work-tree &> /dev/null; then
    return 0
  fi

  local ref
  ref=$(git symbolic-ref HEAD 2> /dev/null) || \
  ref=$(git rev-parse --short HEAD 2> /dev/null) || return 0
  PROMPT+="$(prompt_bold "${ref#refs/heads/}")"

  if git status | grep -E '^[MDAR]' &>/dev/null; then
      PROMPT+="+"
  fi
}

prompt_funcs+=(git_prompt_info)
