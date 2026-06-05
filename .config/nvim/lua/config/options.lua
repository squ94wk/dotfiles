local opt = vim.opt

opt.number = true
opt.wrap = false
opt.timeoutlen = 1000
opt.ttimeoutlen = 0
opt.hidden = true
opt.swapfile = false

opt.completeopt = { "menu", "menuone", "noselect" }
opt.wildmode = "longest:full,full"

opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.smartindent = true

opt.termguicolors = true

opt.mouse = "a"

opt.ignorecase = true
opt.smartcase = true

opt.splitbelow = true
opt.splitright = true

opt.undofile = true
opt.undolevels = 10000

opt.signcolumn = "yes"

opt.scrolloff = 8
opt.sidescrolloff = 8

-- reload files on external changes
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "CursorHoldI", "FocusGained" }, {
  command = "if mode() != 'c' | checktime | endif",
  pattern = { "*" },
})
