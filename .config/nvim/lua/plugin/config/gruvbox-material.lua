local tb = require("utils").toboolean

vim.g.gruvbox_material_background = "soft"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_transparent_background = 1
vim.g.gruvbox_material_enable_italic = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_disable_italic_comment = 0

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "gruvbox-material",
  callback = function()
    if tb(vim.fn.has("termguicolors")) then
      vim.cmd([[set termguicolors]])
    end
    vim.api.nvim_command("hi DiagnosticWarn guifg=#ffb86c")
  end,
})
