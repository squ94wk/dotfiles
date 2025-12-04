return {
  "ray-x/go.nvim",
  dependencies = {
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    local lsp_keymaps = require("config.lsp-keymaps")

    require("go").setup({
      go = "go",
      goimports = "gopls",
      fillstruct = "gopls",
      gofmt = "gopls",
      tag_transform = false,
      lsp_cfg = true,
      lsp_gofumpt = true,
      lsp_on_attach = lsp_keymaps.on_attach,
      lsp_keymaps = false,
      lsp_inlay_hints = {
        enable = false,
      },
      dap_debug = true,
      dap_debug_gui = true,
    })

    local format_sync_grp = vim.api.nvim_create_augroup("goimports", {})
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.go",
      callback = function()
        require("go.format").goimports()
      end,
      group = format_sync_grp,
    })
  end,
  event = { "CmdlineEnter" },
  ft = { "go", "gomod" },
  build = ':lua require("go.install").update_all_sync()',
}
