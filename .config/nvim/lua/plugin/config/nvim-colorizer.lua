require("colorizer").setup()
vim.api.nvim_create_autocmd({ "ColorScheme", "BufReadPost" }, {
  pattern = "*",
  callback = function()
    vim.api.nvim_command([[ColorizerToggle]])
  end,
})
vim.defer_fn(function()
  vim.api.nvim_command([[ColorizerAttachToBuffer]])
end, 0)
