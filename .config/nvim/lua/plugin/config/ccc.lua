local ccc = require("ccc")
local mapping = ccc.mapping
if vim.o.termguicolors then
  ccc.setup({})
  local enable_colorizer = function()
    vim.cmd([[CccHighlighterEnable]])
  end
  vim.api.nvim_create_autocmd({ "ColorScheme", "BufReadPost" }, {
    pattern = "*",
    callback = enable_colorizer,
  })
  vim.defer_fn(enable_colorizer, 0)
end
