ZSH="${HOME}/.zsh"
source "${ZSH}/env.zsh"
source "${ZSH}/functions.zsh"
source "${ZSH}/prompt.zsh"
source "${ZSH}/dirs.zsh"
source "${ZSH}/aliases.zsh"
source "${ZSH}/autocomplete.zsh"
source "${ZSH}/local.zsh"

# plugins
source "${ZSH}/plugins/syntax-highlighting/zsh-syntax-highlighting.zsh"
source "${ZSH}/plugins/autosuggestions/zsh-autosuggestions.zsh"
source "${ZSH}/plugins/completions/zsh-completions.plugin.zsh"
source "${ZSH}/plugins/zvm/zsh-vi-mode.plugin.zsh"

ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT
ZVM_KEYTIMEOUT=0.2
# from sothmoth' zsh-vim-mode plugin
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
#/from sothmoth' zsh-vim-mode plugin
zvm_after_init_commands+=("zvm_bindkey viins '^P' history-beginning-search-backward-end")
zvm_after_init_commands+=("zvm_bindkey viins '^N' history-beginning-search-forward-end")
zvm_after_init_commands+=("zvm_bindkey viins '^ ' forward-word")
zvm_after_init_commands+=("zvm_bindkey vicmd '^ ' forward-word")

setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_verify
setopt inc_append_history
setopt share_history
HISTSIZE=10000
HISTFILE="${HOME}/.zsh_history"
SAVEHIST=10000

TERM=xterm-256color

# Default color is not visible on solarized dark
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=240'

zstyle ':completion:*' menu select

if [[ -n $IDEA_TERMINAL ]]; then
	bindkey "\e\eOD" backward-word
	bindkey "\e\eOC" forward-word
#	bindkey "^[a" beginning-of-line
#	bindkey "^[e" end-of-line
fi

