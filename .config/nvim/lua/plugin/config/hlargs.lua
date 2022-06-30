require("hlargs").setup()
vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    require("hlargs").enable()
  end,
})
