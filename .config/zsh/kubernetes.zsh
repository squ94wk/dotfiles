if [[ "$UPDATE" == "true" ]]; then
    if which kubectl &>/dev/null; then
        sudo ln -sfn "$(which kubectl)" "$(dirname "$(which kubectl)")/k"
        kubectl completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_kubectl"
    fi

    if which helm &>/dev/null; then
        helm completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_helm"
    fi

    if which kind &>/dev/null; then
        kind completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_kind"
    fi
fi

compdef _kubectl k
