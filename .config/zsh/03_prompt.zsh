prompt_dir() {
    PROMPT+=$(style "%~" color ${prompt_colors[yellow_1]})
}
prompt_funcs+=(prompt_dir)
