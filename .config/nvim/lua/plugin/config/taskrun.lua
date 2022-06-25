local plugin_name = "taskrun"

local function loading()
  require(plugin_name).setup()
  vim.keymap.set("n", "[make]m", "<Cmd>TaskRunToggle<CR>", { silent = true })
  vim.keymap.set("n", "[make]q", "<Cmd>TaskRunToggle<CR>", { silent = true })
  vim.keymap.set("n", "[make]r", "<Cmd>TaskRunLast()<CR>", { silent = true })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
