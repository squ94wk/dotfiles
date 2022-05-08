#!/usr/bin/env zsh

function prompt_bold() {
    printf "%%B%s%%b" "$@"
}

function prompt_color() {
    local color="$1"
    shift
    printf "%%F{$color}%s%%f" "$@"
}

ZSH_PROMPT_COLOR_NEUTRAL=246
ZSH_PROMPT_COLOR_USERNAME=103
ZSH_PROMPT_COLOR_AT=104
ZSH_PROMPT_COLOR_HOSTNAME=103
ZSH_PROMPT_COLOR_PATH=214
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

USER_PROMPTS=
export USER_PROMPTS
prompt_add() {
    USER_PROMPTS+=" "
    USER_PROMPTS+="$1"
}

prompt_print_user_prompts() {
    eval "echo -ne \"${USER_PROMPTS}\""
}

setopt PROMPT_SUBST
PROMPT='%{%k%}'
PROMPT+='$(prompt_color ${ZSH_PROMPT_COLOR_PATH} "%~")'
PROMPT+='$(prompt_print_user_prompts)'
PROMPT+='
'
PROMPT+='$(prompt_color ${ZSH_PROMPT_COLOR_VIM_MODE_LEFT} "${ZSH_PROMPT_VIM_MODE_INDICATOR} ")'
PROMPT+='%{%f%k%b%}'

for file in "${ZSH}"/prompt/*.zsh; do
    source "${file}"
done

