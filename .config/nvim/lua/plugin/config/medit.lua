local plugin_name = "medit"

local function loading()
  vim.g.medit_no_mapping = 1
  vim.keymap.set("n", "<leader>q", "<Plug>MEdit")
end

loading()
