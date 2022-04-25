local plugin_name = "onedark"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	require("utils.plugin").load(plugin_name)
	require(plugin_name).setup({
		style = "darker",
		transparent = true,
		term_colors = true,
		ending_tildes = true,
		toggle_style_key = "<leader>ws",
		code_style = {
			comments = "italic",
			keywords = "italic",
			functions = "bold",
			strings = "none",
			variables = "none",
		},
		highlights = {
			rainbowcol1 = { fg = "#7645c4" },
			TSPunctBracket = { fg = "#7645c4" },
		},
		diagnostics = {
			darker = true, -- darker colors for diagnostic
			undercurl = true, -- use undercurl instead of underline for diagnostics
			background = true, -- use background color for virtual text
		},
	})
	require(plugin_name).load()
end

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "onedark",
	callback = loading,
})
