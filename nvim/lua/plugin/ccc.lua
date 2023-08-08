return {
	"uga-rosa/ccc.nvim",
	cond = vim.o.termguicolors and not is_vscode(),
	event = { "BufReadPost" },
	opts = {
		highlighter = {
			auto_enable = true,
			lsp = true,
		},
	},
}
