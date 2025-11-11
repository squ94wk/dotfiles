# FZF completion optimization

# Limit the height and use better tiebreak
export FZF_COMPLETION_OPTS="--height 40% --tiebreak=chunk --bind=ctrl-/:toggle-preview"

# Default fzf options
export FZF_DEFAULT_OPTS="--height 40% --reverse --border"

# Autocomplete common prefix before showing fzf (more traditional behavior)
export FZF_COMPLETION_AUTO_COMMON_PREFIX=true

# If using tmux, configure fzf-tmux
# export FZF_TMUX_HEIGHT=40%

# Configure fzf to use fd for faster file search
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'

_fzf_compgen_path() {
  fd --hidden --follow \
    --max-depth 6 \
    --exclude ".git" \
    --exclude "node_modules" \
    --exclude ".cache" \
    --exclude "target" \
    --exclude "build" \
    --exclude "dist" \
    --exclude ".next" \
    --exclude "Library" \
    --exclude ".npm" \
    --exclude ".cargo" \
    --exclude "__pycache__" \
    --exclude ".venv" \
    --exclude "venv" \
    . "$1"
}

_fzf_compgen_dir() {
  fd --type d --hidden --follow \
    --max-depth 6 \
    --exclude ".git" \
    --exclude "node_modules" \
    --exclude ".cache" \
    --exclude "target" \
    --exclude "build" \
    --exclude "dist" \
    --exclude ".next" \
    --exclude "Library" \
    --exclude ".npm" \
    --exclude ".cargo" \
    --exclude "__pycache__" \
    --exclude ".venv" \
    --exclude "venv" \
    . "$1"
}
