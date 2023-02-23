return {
  "rebelot/kanagawa.nvim",
  priority = vim.env.NVIM_COLORSCHEME == "kanagawa" and 1000 or 50,
  lazy = vim.env.NVIM_COLORSCHEME ~= "kanagawa",
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
