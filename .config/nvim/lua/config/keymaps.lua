local keymap = vim.keymap.set

keymap("n", "q:", "<nop>")
keymap("n", "Q", "<nop>")

keymap("n", "Y", "y$")

keymap("n", "<C-d>", "<C-d>zz")
keymap("n", "<C-u>", "<C-u>zz")

-- Enable Mac-style navigation (Option+arrows for words, Cmd+arrows for lines/file)
if vim.loop.os_uname().sysname == "Darwin" then
  -- macOS: Option+arrows and Command+arrows
  keymap("n", "<M-Left>", "b")
  keymap("n", "<M-Right>", "w")
  keymap("i", "<M-Left>", "<C-o>b")
  keymap("i", "<M-Right>", "<C-o>w")
  keymap("v", "<M-Left>", "b")
  keymap("v", "<M-Right>", "w")

  keymap("n", "<S-Left>", "^")
  keymap("n", "<S-Right>", "$")
  keymap("i", "<S-Left>", "<C-o>^")
  keymap("i", "<S-Right>", "<C-o>$")
  keymap("v", "<S-Left>", "^")
  keymap("v", "<S-Right>", "$")

  keymap("n", "<S-Up>", "gg")
  keymap("n", "<S-Down>", "G")
  keymap("i", "<S-Up>", "<C-o>gg")
  keymap("i", "<S-Down>", "<C-o>G")
  keymap("v", "<S-Up>", "gg")
  keymap("v", "<S-Down>", "G")
else
  -- Linux: Ctrl+arrows for word navigation (Home/End work by default)
  keymap("n", "<C-Left>", "b")
  keymap("n", "<C-Right>", "w")
  keymap("i", "<C-Left>", "<C-o>b")
  keymap("i", "<C-Right>", "<C-o>w")
  keymap("v", "<C-Left>", "b")
  keymap("v", "<C-Right>", "w")
end

keymap("v", "J", ":m '>+1<CR>gv=gv")
keymap("v", "K", ":m '<-2<CR>gv=gv")

keymap("n", "<leader>e", function()
  local filetype = vim.bo.filetype
  if filetype == "neo-tree" then
    vim.cmd("Neotree close")
  else
    vim.cmd("Neotree focus")
  end
end, { desc = "Toggle/focus file tree" })

keymap("n", "<leader>ff", function()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local make_entry = require("telescope.make_entry")
  local action_state = require("telescope.actions.state")
  local actions = require("telescope.actions")

  local current_type = "f" -- Default to files

  pickers.new({}, {
    prompt_title = "Find Files/Dirs (add / for dirs only)",
    finder = finders.new_oneshot_job(
      vim.tbl_flatten({ "fd", "--type", current_type, "--hidden", "--no-ignore-parent" }),
      { entry_maker = make_entry.gen_from_file() }
    ),
    previewer = conf.file_previewer({}),
    sorter = conf.file_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      -- Smart refresh to check for trailing slash
      local function smart_refresh()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt = picker:_get_prompt()
        local new_type = prompt:match("/$") and "d" or "f"

        if new_type ~= current_type then
          current_type = new_type
          picker:refresh(
            finders.new_oneshot_job(
              vim.tbl_flatten({ "fd", "--type", new_type, "--hidden", "--no-ignore-parent" }),
              { entry_maker = make_entry.gen_from_file() }
            ),
            { reset_prompt = false }
          )
        end
      end

      -- Smart open: directories go to neo-tree, files open normally
      local function smart_open()
        local entry = action_state.get_selected_entry()
        local entry_path = entry.path or entry.filename or entry.value

        if vim.fn.isdirectory(entry_path) == 1 then
          actions.close(prompt_bufnr)
          require("config.telescope-utils").neotree_focus_path(entry_path)
        else
          actions.select_default(prompt_bufnr)
        end
      end

      -- Switch to git_files
      local function switch_to_git_files()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local prompt = picker:_get_prompt()
        actions.close(prompt_bufnr)
        require("telescope.builtin").git_files({ default_text = prompt })
      end

      -- Refresh on input
      vim.api.nvim_create_autocmd("TextChangedI", {
        buffer = prompt_bufnr,
        callback = smart_refresh,
      })

      map("i", "<CR>", smart_open)
      map("i", "<leader>ff", switch_to_git_files)
      return true
    end,
  }):find()
end, { desc = "Find files" })
keymap("n", "<leader>fg", function()
  require("telescope.builtin").live_grep()
end, { desc = "Live grep" })
keymap("n", "<leader>fb", function()
  require("telescope.builtin").buffers({
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")
      map("i", "<CR>", actions.select_default)
      return true
    end,
    default_selection_index = 2,
  })
end, { desc = "Find buffers" })
keymap("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Help tags" })
keymap("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Recent files" })

keymap("n", "<leader>gt", "<cmd>GoTest<cr>", { desc = "Go test" })
keymap("n", "<leader>gtf", "<cmd>GoTestFunc<cr>", { desc = "Go test function" })
keymap("n", "<leader>gtr", "<cmd>GoTestFile<cr>", { desc = "Go test file" })
keymap("n", "<leader>gc", "<cmd>GoCoverage<cr>", { desc = "Go coverage" })

keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

keymap("n", "<leader>h", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })
