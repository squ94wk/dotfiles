if [[ "$UPDATE" == "true" ]]; then
    if which docker &>/dev/null; then
        docker completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_docker"
    fi
fi
