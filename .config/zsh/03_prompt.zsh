# Build PROMPT using variable expansion
PROMPT='$(
    left="$(style "%~" color ${prompt_colors[yellow_1]})${PROMPT_GIT}${PROMPT_KUBE}"
    right="${PROMPT_CMD_DURATION}$(style "%D{%I:%M:%S%p}" color "${prompt_colors[blue_1]}")"
    echo -n "${left}$(prompt_padding "$left" "$right")${right}"
)
$(style "${MODE_INDICATOR_PROMPT}" color "${prompt_colors[white_1]}") '
