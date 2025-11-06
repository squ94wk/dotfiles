typeset -g PROMPT_CMD_DURATION=""

function record_cmd_start() {
    cmd_start_time=$SECONDS
}

function record_cmd_end() {
    cmd_code=$?
    if ! [ $cmd_start_time ]; then
        unset cmd_time
        unset cmd_code
        PROMPT_CMD_DURATION=""
        return
    fi
    cmd_time=$((SECONDS - cmd_start_time))
    unset cmd_start_time

    local hours=$((cmd_time / 60 / 60))
    local mins=$((cmd_time / 60))
    local secs=$((cmd_time % 60))

    if [[ $cmd_time -ge $(( 60 * 60 )) ]]; then
        cmd_time_str="${hours}h${mins}m"
    elif [[ $cmd_time -ge 60 ]]; then
        cmd_time_str="${mins}m${secs}s"
    else
        cmd_time_str="${cmd_time}s"
    fi

    if [[ $cmd_code -eq 0 ]]; then
        PROMPT_CMD_DURATION="$(style "${cmd_time_str} " color "${prompt_colors[green_1]}")"
    else
        PROMPT_CMD_DURATION="$(style "${cmd_time_str} ($cmd_code) " color "${prompt_colors[red_1]}")"
    fi
}

precmd_functions=(record_cmd_end $precmd_functions)
preexec_functions=(record_cmd_start $preexec_functions)

# Build RPROMPT using variable expansion
RPROMPT='${PROMPT_CMD_DURATION}$(style "%D{%I:%M:%S%p}" color "${prompt_colors[blue_1]}")'
