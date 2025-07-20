if [[ "$UPDATE" == "true" ]]; then
    if which devspace &>/dev/null; then
        sudo ln -sfn "$(which devspace)" "$(dirname "$(which devspace)")/v"
        devspace completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_devspace"
    fi
fi
