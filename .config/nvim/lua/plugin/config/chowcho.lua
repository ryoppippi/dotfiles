local plugin_name = "chowcho"

local function loading()
  vim.api.nvim_set_keymap("n", "<Leader>wq", "<CMD>Chowcho<CR>", { noremap = true, silent = true })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
