if [[ "$UPDATE" == "true" ]]; then
    if which vcluster &>/dev/null; then
        sudo ln -sfn "$(which vcluster)" "$(dirname "$(which vcluster)")/v"
        vcluster completion zsh > "${XDG_CACHE_HOME}/zsh/completions/_vcluster"
    fi
fi

compdef _vcluster v
