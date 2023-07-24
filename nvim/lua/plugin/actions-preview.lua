return {
	"aznhe21/actions-preview.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-telescope/telescope.nvim",
	},
	opts = function()
		return {
			telescope = require("telescope.themes").get_dropdown({ winblend = 10 }),
		}
	end,
}
