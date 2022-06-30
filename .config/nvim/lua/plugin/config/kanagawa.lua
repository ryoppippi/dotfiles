local default_colors = require("kanagawa" .. ".colors").setup()
require("kanagawa").setup({
  overrides = {
    rainbowcol1 = { fg = default_colors.br },
  },
  globalStatus = true,
})
if vim.g.colors_name == "kanagawa" then
  vim.cmd([[colorscheme kanagawa]])
end
