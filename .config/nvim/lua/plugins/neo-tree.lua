return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  config = function(_, opts)
    -- Set up full background highlighting for cursor line
    vim.api.nvim_set_hl(0, 'NeoTreeCursorLine', {
      bg = '#3b4252',  -- adjust this color to match your theme
      fg = 'NONE'
    })

    require("neo-tree").setup(opts)

    vim.api.nvim_create_autocmd("VimEnter", {
      callback = function()
        if vim.fn.argc() == 0 then
          vim.cmd("Neotree show")
        end
      end,
    })
  end,
  opts = {
    close_if_last_window = true,
    enable_git_status = true,
    enable_diagnostics = true,
    filesystem = {
      follow_current_file = {
        enabled = true,
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        hide_dotfiles = false,
        hide_gitignored = false,
        never_show = { ".git" },
      },
      -- Don't change vim's working directory when navigating
      hijack_netrw_behavior = "open_default",
    },
    window = {
      position = "left",
      width = 35,
      mappings = {
        ["/"] = "fuzzy_finder",
        ["<esc>"] = function()
          -- Switch to previous window (buffer) instead of closing tree
          vim.cmd("wincmd p")
        end,
        ["<left>"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" and node:is_expanded() then
            -- If current node is an open directory, close it
            require("neo-tree.sources.filesystem").toggle_directory(state, node)
          else
            -- Otherwise, jump to parent node
            require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
          end
        end,
        ["<right>"] = function(state)
          local node = state.tree:get_node()
          if node.type == "directory" then
            if node:is_expanded() then
              -- IntelliJ behavior: on open folder, move to first child instead of closing
              vim.cmd("normal! j")
            else
              require("neo-tree.sources.filesystem.commands").toggle_node(state)
            end
          else
            require("neo-tree.sources.filesystem.commands").open(state)
          end
        end,
      },
    },
    default_component_configs = {
      git_status = {
        symbols = {
          added     = "✚",
          modified  = "",
          deleted   = "✖",
          renamed   = "󰁕",
          untracked = "",
          ignored   = "",
          unstaged  = "󰄱",
          staged    = "",
          conflict  = "",
        },
      },
    },
  },
}
