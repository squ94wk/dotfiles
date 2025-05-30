for file in ${XDG_CONFIG_HOME}/zsh/*.zsh; do
	source "$file"
done

# VIM plugins
if [[ -n $UPDATE_ZSH ]]; then
    ensure_git_repo https://github.com/tpope/vim-surround.git "${XDG_CONFIG_HOME}/vim/plugins/tpope/vim-surround"
    ensure_git_repo https://github.com/tpope/vim-sensible.git "${XDG_CONFIG_HOME}/vim/plugins/tpope/vim-sensible"
    ensure_git_repo https://github.com/justinmk/vim-sneak.git "${XDG_CONFIG_HOME}/vim/plugins/justinmk/vim-sneak"
fi

# TMUX plugins
if [[ -n $UPDATE_ZSH ]]; then
    ensure_git_repo https://github.com/tmux-plugins/tmux-sensible.git "${XDG_CONFIG_HOME}/tmux/plugins/tmux-sensible"
fi

unset UPDATE_ZSH
