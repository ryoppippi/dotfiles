local plugin_name = "nvim-ts-hint-textobject"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.api.nvim_set_keymap("o", "m", "<Cmd>lua require('tsht').nodes()<CR>", { noremap = false, silent = false })
  vim.api.nvim_set_keymap("x", "m", "<Cmd>lua require('tsht').nodes()<CR>", { noremap = true, silent = false })
end

loading()
