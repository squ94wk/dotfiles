#!/usr/bin/env zsh
function git_prompt_info() {
  function print_pretty_ref() {
    local ref
    ref=$(command git "${@}" symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git "${@}" rev-parse --short HEAD 2> /dev/null) || return 0
    printf "%%B%s%%b" "${ref#refs/heads/}"
  }

  if [[ "${HOME}" == "${PWD}" ]]; then
    printf "%s" "dotfiles:"
    print_pretty_ref "dot"
  else
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) = "false" ]]; then
      return 0
    fi
    print_pretty_ref
  fi
}

function exec_after_prompt() {
  set -e

  exec 1>/dev/null
  exec 2>/dev/null

  if [[ -n $TMUX ]]; then
    local pane_count
    pane_count="$(tmux list-panes | wc -l | awk '{ print $1 }')"
    if [[ $pane_count -gt 1 ]]; then
      exit 0
    fi

    local pane_id
    pane_id="${TMUX_PANE}"
    local dir
    dir="$PWD"

    if [ "$HOME" = "$dir" ]; then
      local window_title
      window_title="~"
    else
      local git_root
      git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
      if [ -n "$git_root" ]; then
        dir="$git_root"
      fi

      local window_title
      window_title="$(basename "$dir")"
    fi

    tmux rename-window -t "$pane_id" "$window_title"
  fi
}

ZSH_PROMPT_INITIAL_MODE="viins"

zle-line-init() { zle -K "${ZSH_PROMPT_INITIAL_MODE}"; }
zle -N zle-line-init

ZSH_PROMPT_COLOR_USERNAME=103
ZSH_PROMPT_COLOR_AT=104
ZSH_PROMPT_COLOR_HOSTNAME=103
ZSH_PROMPT_COLOR_PATH=214
ZSH_PROMPT_COLOR_GIT=246
ZSH_PROMPT_COLOR_VIM_MODE_LEFT=246
ZSH_PROMPT_COLOR_VIM_MODE_RIGHT=253

MODE_INDICATOR_PROMPT=' |INITIAL' # workaround: if not set, vi-mode will return early
MODE_INDICATOR_VIINS='>|INSERT'
MODE_INDICATOR_VICMD=':|NORMAL'
MODE_INDICATOR_REPLACE='R|REPLACE'
MODE_INDICATOR_SEARCH='/|SEARCH'
MODE_INDICATOR_VISUAL='v|VISUAL'
MODE_INDICATOR_VLINE='V|V-LINE'

setopt PROMPT_SUBST
PROMPT='%{%k%}'
# show username & host
if in_ssh_session; then
  PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_USERNAME}}%}%n'
  PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_AT}}%}@'
  PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_HOSTNAME}}%}%m '
fi
PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_PATH}}%}%~ '
PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_GIT}}%}$(git_prompt_info)'
PROMPT+='
'
PROMPT+='%{%b%F{${ZSH_PROMPT_COLOR_VIM_MODE_LEFT}}%}${MODE_INDICATOR_PROMPT%|*} '
PROMPT+='%{%f%k%b%}'
PROMPT+='$(exec_after_prompt)'

RPROMPT='%{%B%F{${ZSH_PROMPT_COLOR_VIM_MODE_RIGHT}}%}${MODE_INDICATOR_PROMPT#*|}%{%b%f%}'

