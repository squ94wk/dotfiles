#!/usr/bin/env zsh

# don't print '(venv)' when in virtual env
export VIRTUAL_ENV_DISABLE_PROMPT=1

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

MODE_INDICATOR_VIINS='>'
MODE_INDICATOR_VICMD=':'
MODE_INDICATOR_REPLACE='R'
MODE_INDICATOR_SEARCH='/'
MODE_INDICATOR_VISUAL='v'
MODE_INDICATOR_VLINE='V'

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
PROMPT+='$(prompt_color ${ZSH_PROMPT_COLOR_VIM_MODE_LEFT} "${MODE_INDICATOR_PROMPT} ")'
PROMPT+='%{%f%k%b%}'

