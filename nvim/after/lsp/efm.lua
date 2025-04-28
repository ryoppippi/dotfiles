---@type vim.lsp.Config
return {
	cmd = { "efm-langserver" },
	root_markers = {
		".git",
	},
	single_file_support = true,
	init_options = {
		documentFormatting = true,
		rangeFormatting = true,
		hover = true,
		documentSymbol = true,
		codeAction = true,
		completion = true,
	},
}
