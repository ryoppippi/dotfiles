if vim.o.termguicolors then
  require("colorizer").setup()
  local enable_colorizer = function()
    vim.api.nvim_command([[ColorizerAttachToBuffer]])
  end
  vim.api.nvim_create_autocmd({ "ColorScheme", "BufReadPost" }, {
    pattern = "*",
    callback = enable_colorizer,
  })
  vim.defer_fn(enable_colorizer, 0)
end
