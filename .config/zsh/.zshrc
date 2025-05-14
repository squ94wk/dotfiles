ZSH_PLUGIN_DIR="${XDG_CONFIG_HOME}/zsh/plugins"

# Plugins
source "${ZSH_PLUGIN_DIR}/zsh-vim-mode/zsh-vim-mode.plugin.zsh"
source "${ZSH_PLUGIN_DIR}/fast-syntax-highlighting/F-Sy-H.plugin.zsh"

source "${ZSH_PLUGIN_DIR}/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

source "${ZSH_PLUGIN_DIR}/fzf-tab-completion/zsh/fzf-zsh-completion.sh"
bindkey '^I' fzf_completion

source "${ZSH_PLUGIN_DIR}/zsh-fzf-history-search/zsh-fzf-history-search.zsh"

# Customization

for file in ${XDG_CONFIG_HOME}/zsh/*.zsh; do
	source "$file"
done

zstyle ':completion:*' menu select

autoload -U compinit && compinit

