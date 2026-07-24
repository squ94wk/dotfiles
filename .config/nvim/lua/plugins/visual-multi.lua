return {
  "mg979/vim-visual-multi",
  branch = "master",
  lazy = false,
  init = function()
    vim.g.VM_theme = "iceblue"
    vim.g.VM_maps = {
      ["Find Under"] = "gl",
      ["Find Subword Under"] = "gl",
      ["Skip Region"] = "gx",
      ["Remove Region"] = "gp",
      ["Select All"] = "ga",
    }
  end,
}
