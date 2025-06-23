# don't print '(venv)' when in virtual env
export VIRTUAL_ENV_DISABLE_PROMPT=1

USER_PROMPTS=
USER_PROMPTS_NEWLINE=
USER_RPROMPTS=
export USER_PROMPTS
export USER_RPROMPTS
export USER_PROMPTS_NEWLINE

prompt_add() {
    case $1 in
        right)
            USER_RPROMPTS+=" $2"
            ;;
        left)
            USER_PROMPTS+=" $2"
            ;;
        newline)
            USER_PROMPTS_NEWLINE+=" $2"
            ;;
        *)
            USER_PROMPTS+=" $1"
            ;;
    esac
}

function prompt_bold() {
    printf "%%B%s%%b" "$@"
}

function prompt_color() {
    local color="$1"
    shift
    printf "%%F{$color}%s%%f" "$@"
}

prompt_print_user_prompts() {
    # we wanna expand twice
    case $1 in
        right)
            eval "echo -ne \"${USER_RPROMPTS}\""
            ;;
        left)
            eval "echo -ne \"${USER_PROMPTS}\""
            ;;
        newline)
            eval "echo -ne \"${USER_PROMPTS_NEWLINE}\""
            ;;
        *)
            ;;
    esac
}

setopt PROMPT_SUBST

TMOUT=5
TRAPALRM () {
    if pgrep fzf >/dev/null; then
        return;
    fi
    zle reset-prompt
}

PROMPT='%{%k%}'
PROMPT+='$(prompt_print_user_prompts left)'
PROMPT+='
$(prompt_print_user_prompts newline)'
PROMPT+='%{%f%k%b%}'
RPROMPT='$(prompt_print_user_prompts right)'
