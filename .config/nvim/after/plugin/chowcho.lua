local plugin_name = "chowcho"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	vim.api.nvim_set_keymap("n", "<Leader>wq", "<CMD>Chowcho<CR>", { noremap = true, silent = true })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
