return {
	"moonbit-community/moonbit.nvim",
	ft = { "moonbit" },
	cond = not is_vscode(),
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	init = function()
		vim.filetype.add({ extension = { mbt = "moonbit" } })
	end,
	opts = {
		lsp = false,
		jsonls = false,
	},
}
