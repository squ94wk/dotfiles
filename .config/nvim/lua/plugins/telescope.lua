return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")

    -- Custom action to switch between find_files and git_files
    local function switch_to_git_files(prompt_bufnr)
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local current_prompt = current_picker:_get_prompt()
      actions.close(prompt_bufnr)
      require("telescope.builtin").git_files({ default_text = current_prompt })
    end

    local function switch_to_find_files(prompt_bufnr)
      local current_picker = action_state.get_current_picker(prompt_bufnr)
      local current_prompt = current_picker:_get_prompt()
      actions.close(prompt_bufnr)
      require("telescope.builtin").find_files({ default_text = current_prompt, hidden = true, no_ignore_parent = true })
    end

    -- Custom action: open directories in neo-tree, files normally
    local function smart_open(prompt_bufnr)
      local entry = action_state.get_selected_entry()
      local entry_path = entry.path or entry.filename or entry.value

      if vim.fn.isdirectory(entry_path) == 1 then
        actions.close(prompt_bufnr)
        require("config.telescope-utils").neotree_focus_path(entry_path)
      else
        actions.select_default(prompt_bufnr)
      end
    end

    telescope.setup({
      defaults = {},
      pickers = {
        find_files = {
          hidden = true,
          no_ignore_parent = true,
          find_command = { "fd", "--type", "f", "--type", "d" },
          mappings = {
            i = {
              ["<leader>ff"] = switch_to_git_files,
              ["<CR>"] = smart_open,
            },
          },
        },
        git_files = {
          mappings = {
            i = {
              ["<leader>ff"] = switch_to_find_files,
              ["<CR>"] = smart_open,
            },
          },
        },
        oldfiles = {
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
        },
        buffers = {
          initial_mode = "normal",
          sort_mru = true,
          ignore_current_buffer = false,
        },
      },
    })

    telescope.load_extension("fzf")
  end,
}
