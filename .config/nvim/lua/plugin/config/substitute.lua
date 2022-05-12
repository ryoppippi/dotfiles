local plugin_name = "substitute"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require(plugin_name).setup()
end

require("utils.plugin").force_load_on_event(plugin_name, loading)

vim.keymap.set("n", "<leader>c", "<cmd>lua require('substitute').operator()<cr>", { noremap = true })
vim.keymap.set("x", "<leader>c", "<cmd>lua require('substitute').visual()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>cc", "<cmd>lua require('substitute').line()<cr>", { noremap = true })
vim.keymap.set("n", "<leader>C", "<cmd>lua require('substitute').eol()<cr>", { noremap = true })
