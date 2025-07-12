prompt_dir() {
    PROMPT+=$(prompt_color ${ZSH_COLOR_PRIMARY} "%~")
}
prompt_funcs+=(prompt_dir)
