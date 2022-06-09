local plugin_name = "medit"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.g.medit_no_mapping = 1
  vim.keymap.set("n", "<leader>q", "<Plug>MEdit")
end

loading()
