function record_cmd_start() {
    cmd_start_time=$SECONDS
}

function record_cmd_end() {
    cmd_code=$?
    if ! [ $cmd_start_time ]; then
        unset cmd_time
        unset cmd_code
        return
    fi
    cmd_time=$((SECONDS - cmd_start_time))
    unset cmd_start_time
}

add-zsh-hook preexec record_cmd_start
add-zsh-hook precmd record_cmd_end

function prompt_cmd_duration() {
    if ! [ $cmd_time ]; then
        return
    fi

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
        echo "%F{green}${cmd_time_str}%f"
    else
        echo "%F{red}${cmd_time_str} ($cmd_code)%f"
    fi
}

prompt_add right '$(prompt_cmd_duration)'
prompt_add right '%F{blue}%D{%I:%M:%S%p}%f'
