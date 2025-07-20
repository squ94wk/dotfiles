if [[ -d "${XDG_DATA_HOME}/npm/bin" ]]; then
    path+=("${XDG_DATA_HOME}/npm/bin")
fi

if which npm &>/dev/null; then
    if [[ "$UPDATE" == "true" ]]; then
        sudo ln -sfn "$(which npm)" "$(dirname "$(which npm)")/n"
        npm completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_npm"
        npm set prefix "${XDG_DATA_HOME}/npm"
    fi
fi
