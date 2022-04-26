local plugin_name = "scrollbar"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	require("scrollbar.handlers.search").setup()
	require(plugin_name).setup({
		handlers = {
			diagnostic = true,
			search = true,
		},
		handle = {
			color = "#63768A",
		},
	})
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
vim.api.nvim_create_autocmd("VimEnter", {
	callback = loading,
})
