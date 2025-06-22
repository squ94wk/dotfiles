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

USER_PROMPTS=
USER_RPROMPTS=
export USER_PROMPTS
export USER_RPROMPTS
prompt_add() {
    case $1 in
        right)
            USER_RPROMPTS+=" $2"
            ;;
        left)
            USER_PROMPTS+=" $2"
            ;;
        *)
            USER_PROMPTS+=" $1"
            ;;
    esac
}

prompt_print_user_prompts() {
    # we wanna expand twice
    eval "echo -ne \"${USER_PROMPTS}\""
}

prompt_print_user_rprompts() {
    # we wanna expand twice
    eval "echo -ne \"${USER_RPROMPTS}\""
}

setopt PROMPT_SUBST

TMOUT=5
TRAPALRM () {
    if pgrep fzf >/dev/null; then
        return;
    fi
    zle reset-prompt
}

prompt_add '$(prompt_color ${ZSH_PROMPT_COLOR_PATH} "%~")'

PROMPT='%{%k%}'
PROMPT+='$(prompt_print_user_prompts)'
PROMPT+='%{%f%k%b%}'
RPROMPT='$(prompt_print_user_rprompts)'
