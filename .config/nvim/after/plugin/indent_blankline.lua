local plugin_name = "indent_blankline"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	vim.opt.termguicolors = true

	require(plugin_name).setup({
		-- show_end_of_line = true,
		show_current_context = true,
		show_current_context_start = true,
	})
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
