local M = {
  "uga-rosa/ccc.nvim",
  event = { "VeryLazy" },
  enabaled = vim.o.termguicolors,
}

M.config = function()
  require("ccc").setup({})
  vim.cmd([[CccHighlighterDisable]])
  vim.cmd([[CccHighlighterEnable]])
  vim.api.nvim_create_autocmd({ "ColorScheme", "BufReadPost" }, {
    pattern = "*",
    callback = M.config,
  })
end

return M
