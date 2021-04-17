#!/usr/bin/env zsh
function git_prompt_info() {
  function print_pretty_ref() {
    local ref
    ref=$(command git "${@}" symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git "${@}" rev-parse --short HEAD 2> /dev/null) || return 0
    printf "%%B%s%%b" "${ref#refs/heads/}"
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

ZSH_PROMPT_COLOR_USERNAME=103
ZSH_PROMPT_COLOR_AT=104
ZSH_PROMPT_COLOR_HOSTNAME=103
ZSH_PROMPT_COLOR_PATH=214
ZSH_PROMPT_COLOR_GIT=246
ZSH_PROMPT_COLOR_VIM_MODE_LEFT=246
ZSH_PROMPT_COLOR_VIM_MODE_RIGHT=253

function zvm_after_select_vi_mode() {
  case $ZVM_MODE in
    $ZVM_MODE_NORMAL)
        ZSH_PROMPT_VIM_MODE_INDICATOR=':'
    ;;
    $ZVM_MODE_INSERT)
        ZSH_PROMPT_VIM_MODE_INDICATOR='>'
    ;;
    $ZVM_MODE_VISUAL)
        ZSH_PROMPT_VIM_MODE_INDICATOR='v'
    ;;
    $ZVM_MODE_VISUAL_LINE)
        ZSH_PROMPT_VIM_MODE_INDICATOR='V'
    ;;
    $ZVM_MODE_REPLACE)
        ZSH_PROMPT_VIM_MODE_INDICATOR='R'
    ;;
  esac
}

setopt PROMPT_SUBST
PROMPT='%{%k%}'
# show username & host
if in_ssh_session; then
  PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_USERNAME}}%}%n'
  PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_AT}}%}@'
  PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_HOSTNAME}}%}%m '
fi
PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_PATH}}%}%~ '
PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_GIT}}%}$(git_prompt_info)'
PROMPT+='
'
PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_VIM_MODE_LEFT}}%}${ZSH_PROMPT_VIM_MODE_INDICATOR} '
PROMPT+='%{%f%k%b%}'

