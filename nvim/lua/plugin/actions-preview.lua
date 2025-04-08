---@type LazySpec
return {
	"aznhe21/actions-preview.nvim",
	event = "LspAttach",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
	},
	cond = not is_vscode(),
	opts = function()
		return {
			telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
		}
	end,
}
