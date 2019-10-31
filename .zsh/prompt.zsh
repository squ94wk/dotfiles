#!/usr/bin/env zsh
function git_prompt_info() {
  function print_pretty_ref() {
    local ref
    ref=$(command git "${@}" symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git "${@}" rev-parse --short HEAD 2> /dev/null) || return 0
    printf "%s" "${ref#refs/heads/}"
  }

  if [[ "${HOME}" == "${PWD}" ]]; then
    printf "%s" "dotfiles:"
    print_pretty_ref "--git-dir=${HOME}/.dotfiles" "--work-tree=${HOME}"
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

zle-line-init() { zle -K vicmd; }
zle -N zle-line-init

setopt PROMPT_SUBST
PROMPT='%{%k%}%{%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%}:%{%b%F{yellow}%}%~ %{%B%F{cyan}%}$(git_prompt_info)
%{%f%k%b%}$(exec_after_prompt)'

RPROMPT='%{%B%F{cyan}%}${MODE_INDICATOR_PROMPT}%{%b%f%}'

