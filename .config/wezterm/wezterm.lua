local wezterm = require 'wezterm'

local config = wezterm.config_builder()

-- config.default_prog = { '/opt/homebrew/bin/zsh', '-c', '/opt/homebrew/bin/tmux a -t 1 || /opt/homebrew/bin/tmux' }
config.default_prog = {
  '/opt/homebrew/bin/zsh',
  '-c',
  'pgrep tmux >/dev/null && exec /opt/homebrew/bin/zsh || exec /opt/homebrew/bin/tmux new -s work'
}

config.font = wezterm.font 'JetBrains Mono'
config.font_size = 16

config.keys = {
  -- prevent closing window
  {
    key = 'w',
    mods = 'CMD',
    action = wezterm.action.SendKey { key = 'w', mods = 'CTRL' },
  },
}

config.colors = {
  foreground = "#e0e0e0",
  background = "#000000",

  ansi = {
    "#252525", -- black
    "#ef3032", -- red
    "#3bab10", -- green
    "#fdb300", -- yellow
    "#6495ed", -- blue
    "#de4fb8", -- magenta
    "#4ebbb9", -- cyan
    "#c8c8c8", -- white
  },

  brights = {
    "#454545", -- bright black
    "#fc7676", -- bright red
    "#b6e354", -- bright green
    "#fd971f", -- bright yellow
    "#87ceeb", -- bright blue
    "#99008e", -- bright magenta
    "#87ebda", -- bright cyan
    "#fdfdfd", -- bright white
  },
}

config.term = 'wezterm'

return config
