local M = {
  "uga-rosa/ccc.nvim",
  event = { "VeryLazy" },
  enabaled = vim.o.termguicolors,
}

M.enable_ccc = function()
  require("ccc").setup({})
  vim.cmd([[CccHighlighterDisable]])
  vim.cmd([[CccHighlighterEnable]])
end
M.config = function()
  vim.api.nvim_create_autocmd({ "ColorScheme", "BufReadPost" }, {
    pattern = "*",
    callback = M.enable_ccc,
  })
end

return M
