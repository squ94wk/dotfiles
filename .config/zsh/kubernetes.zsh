if [[ "$UPDATE" == "true" ]]; then
    if which kubectl &>/dev/null; then
        sudo ln -sfn "$(which kubectl)" "$(dirname "$(which kubectl)")/k"
        kubectl completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_kubectl"
    fi
fi

compdef _kubectl k
