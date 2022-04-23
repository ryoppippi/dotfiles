local plugin_name = "hlargs"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	hlargs.setup()
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = loading,
})
