# Build PROMPT using variable expansion
PROMPT='$(style "%~" color ${prompt_colors[yellow_1]})${PROMPT_GIT}${PROMPT_KUBE}
$(style "${MODE_INDICATOR_PROMPT}" color "${prompt_colors[white_1]}") '
