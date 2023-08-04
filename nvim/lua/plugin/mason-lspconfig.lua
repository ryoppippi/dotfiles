return {
	"williamboman/mason-lspconfig.nvim",
	cond = not is_vscode(),
	dependencies = {
		"folke/neoconf.nvim",
		"williamboman/mason.nvim",
	},
	config = function()
		require("mason")
		local mason_lspconfig = require("mason-lspconfig")

		mason_lspconfig.setup({
			ensure_installed = {
				"emmet_ls",
				"tailwindcss",
				"stylelint_lsp",
				"tsserver",
				"eslint",
				"denols",
				"svelte",
				"angularls",
				"astro",
				"prismals",
				"pyright",
				"r_language_server",
				"rust_analyzer",
				-- "zls",
				"lua_ls",
				"gopls",
				"sqlls",
				"jsonls",
				"yamlls",
			},
		})
	end,
}
