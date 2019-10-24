git_prompt_info() {
  local ref
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) = "false" ]]; then
    return 0
  fi
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo "${ref#refs/heads/}"
  fi
}

function exec_after_prompt() {
  set -e

  exec 1>/dev/null
  exec 2>/dev/null

  if ! [[ -z $TMUX ]]; then
    local pane_count="$(tmux list-panes | wc -l | awk '{ print $1 }')"
    if [[ $pane_count -gt 1 ]]; then
      exit 0
    fi

    local pane_id="${TMUX_PANE}"
    local dir="$PWD"

    if [ "$HOME" = "$dir" ]; then
      local window_title="~"
    else
      local git_root="$(git rev-parse --show-toplevel 2>/dev/null)"
      if ! [ -z "$git_root" ]; then
        dir="$git_root"
      fi

      local window_title="$(basename $dir)"
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

