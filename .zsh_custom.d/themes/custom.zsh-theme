function parse_git_dirty() {}

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

PROMPT='%{%k%}%{%B%F{green}%}%n%{%B%F{blue}%}@%{%B%F{cyan}%}%m%{%B%F{green}%}:%{%b%F{yellow}%}%~ %{%B%F{cyan}%}$(git_prompt_info)
%{%f%k%b%}$(exec_after_prompt)'

RPROMPT=''

ZSH_THEME_GIT_PROMPT_PREFIX=''
ZSH_THEME_GIT_PROMPT_SUFFIX=''
