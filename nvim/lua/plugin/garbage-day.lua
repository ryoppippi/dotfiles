return {
	"zeioth/garbage-day.nvim",
	dependencies = "neovim/nvim-lspconfig",
	event = "LSPAttach",
	opts = {
		excluded_lsp_clients = { "efm" },
	},
}
