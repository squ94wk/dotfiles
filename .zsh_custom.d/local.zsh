# The next line updates PATH for the Google Cloud SDK.
if [ -f "${HOME}/gcloud-sdk/path.zsh.inc" ]; then . "${HOME}/gcloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "${HOME}/gcloud-sdk/completion.zsh.inc" ]; then . "${HOME}/gcloud-sdk/completion.zsh.inc"; fi

# SDKman
export SDKMAN_DIR="${HOME}/.sdkman"
[[ -s "${SDKMAN_DIR}/bin/sdkman-init.sh" ]] && source "${SDKMAN_DIR}/bin/sdkman-init.sh"
