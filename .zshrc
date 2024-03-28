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
source "${ZSH}/plugins/vim-mode/zsh-vim-mode.plugin.zsh"
prompt_add "${MODE_INDICATOR_PROMPT} "
MODE_INDICATOR_VIINS='>'
MODE_INDICATOR_VICMD=':'
MODE_INDICATOR_REPLACE='R'
MODE_INDICATOR_SEARCH='/'
MODE_INDICATOR_VISUAL='v'
MODE_INDICATOR_VLINE='V'


# Autocomplete shortcuts
bindkey -M viins '^P' history-beginning-search-backward-end
bindkey -M viins '^N' history-beginning-search-forward-end
bindkey -M viins '^ ' forward-word
bindkey -M vicmd '^ ' forward-word

# Cursor in VIM modes
KEYTIMEOUT=1
MODE_CURSOR_VIINS="#00ff00 blinking bar"
MODE_CURSOR_REPLACE="$MODE_CURSOR_VIINS #ff0000"
MODE_CURSOR_VICMD="green block"
MODE_CURSOR_SEARCH="#ff00ff steady underline"
MODE_CURSOR_VISUAL="$MODE_CURSOR_VICMD steady bar"
MODE_CURSOR_VLINE="$MODE_CURSOR_VISUAL #00ffff"

# History
setopt hist_ignore_space
setopt hist_ignore_dups
setopt hist_verify
setopt inc_append_history
setopt share_history
HISTSIZE=100000
HISTFILE="${HOME}/.zsh_history"
SAVEHIST=100000

zstyle ':completion:*' menu select

