local plugin_name = "chowcho"

local function loading()
  vim.keymap.set("n", "<Leader>wq", "<CMD>Chowcho<CR>", { silent = true })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
