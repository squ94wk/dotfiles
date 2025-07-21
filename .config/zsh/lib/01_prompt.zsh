# don't print '(venv)' when in virtual env
export VIRTUAL_ENV_DISABLE_PROMPT=1

prompt_funcs=()
newline_prompt_funcs=()
prompt_setup_prompts() {
    { # prevent inderupts when prompt is "drawn"
        trap '' INT
        PROMPT=''
        RPROMPT=''
        for func in $prompt_funcs $newline_prompt_funcs; do
            $func
        done
        PROMPT+=' '
    } always {
        trap - INT
    }
}

add-zsh-hook precmd prompt_setup_prompts

function prompt_bold() {
    printf "%%B%s%%b" "$@"
}


function _reset_prompt {
    prompt_setup_prompts
    zle .reset-prompt
}
zle -N reset-prompt _reset_prompt

TMOUT=5
TRAPALRM () {
    if [[ ! "$WIDGET" =~ ^fzf_.*$ ]]; then
        zle reset-prompt
    fi
}
