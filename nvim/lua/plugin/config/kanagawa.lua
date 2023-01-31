return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  opts = function()
    local default_colors = require("kanagawa.colors").setup()
    return {
      overrides = {
        rainbowcol1 = { fg = default_colors.br },
      },
      globalStatus = true,
      transparent = true,
    }
  end,
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme("kanagawa")
  end,
}
