for env_file in "$(dirname "$0")"/env/*.zsh; do
    source "${env_file}"
done
