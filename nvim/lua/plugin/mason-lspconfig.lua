return {
	"williamboman/mason-lspconfig.nvim",
	cond = not is_vscode(),
	dependencies = {
		"folke/neoconf.nvim",
		"williamboman/mason.nvim",
	},
	opts = {
		ensure_installed = {},
	},
	config = function(_, opts)
		require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup(opts)
	end,
}
