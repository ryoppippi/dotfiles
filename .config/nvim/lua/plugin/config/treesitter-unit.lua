local plugin_name = "treesitter-unit"

local function loading()
  vim.api.nvim_set_keymap("x", "iu", ':lua require"treesitter-unit".select()<CR>', { noremap = true })
  vim.api.nvim_set_keymap("x", "au", ':lua require"treesitter-unit".select(true)<CR>', { noremap = true })
  vim.api.nvim_set_keymap("o", "iu", ':<c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
  vim.api.nvim_set_keymap("o", "au", ':<c-u>lua require"treesitter-unit".select(true)<CR>', { noremap = true })
  vim.api.nvim_set_keymap("x", "/", ':lua require"treesitter-unit".select()<CR>', { noremap = true })
  vim.api.nvim_set_keymap("o", "/", ':<c-u>lua require"treesitter-unit".select()<CR>', { noremap = true })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
