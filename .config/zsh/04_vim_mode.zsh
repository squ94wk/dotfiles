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

