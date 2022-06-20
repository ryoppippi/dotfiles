local plugin_name = "nvim-ts-hint-textobject"

local function loading()
  vim.api.nvim_set_keymap("o", "m", "<Cmd>lua require('tsht').nodes()<CR>", { noremap = false, silent = false })
  vim.api.nvim_set_keymap("x", "m", "<Cmd>lua require('tsht').nodes()<CR>", { noremap = true, silent = false })
end

loading()
