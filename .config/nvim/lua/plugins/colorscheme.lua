return {
  "nickkadutskyi/jb.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme jb]])
    -- Override background to be darker than jb.nvim's default
    vim.api.nvim_set_hl(0, "Normal", { bg = "#0F0F0F" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#0F0F0F" })
  end,
}
