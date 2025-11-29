---@type LazySpec
return {
	"aznhe21/actions-preview.nvim",
	event = "LspAttach",
	dependencies = {
		"neovim/nvim-lspconfig",
		"folke/snacks.nvim",
	},
	cond = not is_vscode(),
	opts = {
		backend = { "snacks" },
		snacks = {
			layout = {
				preset = "vertical",
				layout = { height = 0.4 },
			},
		},
	},
}
