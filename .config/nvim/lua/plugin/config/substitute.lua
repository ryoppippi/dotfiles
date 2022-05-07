local plugin_name = "substitute"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require(plugin_name).setup()
end

require("utils.plugin").force_load_on_event(plugin_name, loading)

vim.keymap.set("n", "r", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("x", "r", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
vim.keymap.set("n", "rr", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
-- vim.keymap.set("n", "R", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
