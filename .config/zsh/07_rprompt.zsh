function record_cmd_exec() {
    cmd_start_time=$SECONDS
}

add-zsh-hook preexec record_cmd_exec

function prompt_cmd_duration() {
    if [[ $? -eq 0 ]]; then
        CMD_TIME_COLOR="%F{green}"
    else
        CMD_TIME_COLOR="%F{red}"
    fi

    if ! [ $cmd_start_time ]; then
        return
    fi
    local cmd_end_time=$SECONDS
    local cmd_time=$((cmd_end_time - cmd_start_time))
    unset cmd_start_time

    # Format the time to show appropriate units
    if [[ $cmd_time -ge 60 ]]; then
        local mins=$((cmd_time / 60))
        local secs=$((cmd_time % 60))
        cmd_time_str="${mins}m${secs}s"
    else
        cmd_time_str="${cmd_time}s"
    fi

    # Store the formatted time for RPROMPT
    echo "${CMD_TIME_COLOR}${cmd_time_str}%f"
}

ZSH_PROMPT_COLOR_NEUTRAL=246

prompt_add right '$(prompt_color ${ZSH_PROMPT_COLOR_NEUTRAL} "$(prompt_cmd_duration)")'
prompt_add right '%F{blue}%D{%I:%M:%S%p}%f'
