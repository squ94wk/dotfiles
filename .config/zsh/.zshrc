[[ -f "$HOME/.bash_profile" ]] && . "$HOME/.bash_profile"

update() {
    exec env UPDATE=true $(which zsh)
}

if [[ "$UPDATE" == "true" ]]; then
    sudo curl -fsSL "https://gist.github.com/squ94wk/23bda001326aa185de26d2a6b850a180/raw/b728181453aa698a7b646272c435c3bde71b8ce9/ensure_repo.sh" -o "/usr/local/bin/ensure_repo.sh" && sudo chmod +x "/usr/local/bin/ensure_repo.sh"
    sudo curl -fsSL "https://gist.githubusercontent.com/squ94wk/23bda001326aa185de26d2a6b850a180/raw/de3d2dd65470d7abcce580f92f12838e1f074025/install_from_archive.sh" -o "/usr/local/bin/install_from_archive.sh" && sudo chmod +x "/usr/local/bin/install_from_archive.sh"
    echo "Installed software management tooling"
fi

ZSH_PLUGIN_DIR="${XDG_CONFIG_HOME}/zsh/plugins"

# Plugins
if [[ "$UPDATE" == "true" ]]; then
    ensure_repo.sh "https://github.com/softmoth/zsh-vim-mode.git" "${ZSH_PLUGIN_DIR}/zsh-vim-mode"
    ensure_repo.sh "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "${ZSH_PLUGIN_DIR}/fast-syntax-highlighting"
    ensure_repo.sh "https://github.com/zsh-users/zsh-autosuggestions" "${ZSH_PLUGIN_DIR}/zsh-autosuggestions"
    ensure_repo.sh "https://github.com/lincheney/fzf-tab-completion.git" "${ZSH_PLUGIN_DIR}/fzf-tab-completion"
    ensure_repo.sh "https://github.com/joshskidmore/zsh-fzf-history-search.git" "${ZSH_PLUGIN_DIR}/zsh-fzf-history-search"
fi

source "${ZSH_PLUGIN_DIR}/zsh-vim-mode/zsh-vim-mode.plugin.zsh"
source "${ZSH_PLUGIN_DIR}/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history)

#####
# from https://www.reddit.com/r/zsh/comments/hextyh/zshautosuggestions_use_arrow_left_for_partial/
#####

# Remove forward-char widgets from ACCEPT
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#forward-char}")
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS=("${(@)ZSH_AUTOSUGGEST_ACCEPT_WIDGETS:#vi-forward-char}")

# Add forward-char widgets to PARTIAL_ACCEPT
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(forward-char)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(vi-forward-char)

# Add custom widget to complete partial if cursor is at end of buffer
autosuggest_partial_wordwise () {
    if [[ $CURSOR -lt ${#BUFFER} && $KEYMAP != vicmd ||
          $CURSOR -lt $((${#BUFFER} - 1)) ]]; then
        zle forward-char
    else
        zle forward-word
    fi
}
zle -N autosuggest_partial_wordwise
bindkey "^[[C" autosuggest_partial_wordwise

# Add autosuggest_partial_wordwise to IGNORE
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(autosuggest_partial_wordwise)
#####
# end
#####

source "${ZSH_PLUGIN_DIR}/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
bindkey '^I' fzf_completion
source "${ZSH_PLUGIN_DIR}/zsh-fzf-history-search/zsh-fzf-history-search.zsh"

# init completion
completion_dir="${XDG_CACHE_HOME}/zsh/completions"
fpath=("$completion_dir" $fpath)

mkdir -p "$completion_dir"
# fistyle ':completion:*' menu select
autoload -U compinit && compinit

# Customization
for file in ${XDG_CONFIG_HOME}/zsh/lib/*.zsh; do
	source "$file"
done
for file in ${XDG_CONFIG_HOME}/zsh/*.zsh; do
	source "$file"
done

# VIM plugins
if [[ "$UPDATE" == "true" ]]; then
    ensure_repo.sh https://github.com/tpope/vim-surround.git "${XDG_CONFIG_HOME}/vim/pack/plugins/start/vim-surround"
    ensure_repo.sh https://github.com/tpope/vim-sensible.git "${XDG_CONFIG_HOME}/vim/pack/plugins/start/vim-sensible"
    ensure_repo.sh https://github.com/justinmk/vim-sneak.git "${XDG_CONFIG_HOME}/vim/pack/plugins/start/vim-sneak"
fi

# TMUX plugins
if [[ "$UPDATE" == "true" ]]; then
    ensure_repo.sh https://github.com/tmux-plugins/tmux-sensible.git "${XDG_CONFIG_HOME}/tmux/plugins/tmux-sensible"
fi

unset UPDATE
