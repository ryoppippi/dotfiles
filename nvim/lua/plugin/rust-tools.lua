return {
	"simrat39/rust-tools.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
		{
			"williamboman/mason-lspconfig.nvim",
			opts = function(_, opts)
				opts.ensure_installed = vim.tbl_flatten({
					opts.ensure_installed or {},
					{
						"rust_analyzer",
					},
				})
			end,
		},
	},
	cond = not is_vscode(),
	event = {
		"BufReadPre *.rs",
		"BufNewFile *.rs",
		"VeryLazy",
	},
	opts = function()
		local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
		return {
			server = {
				capabilities = lspconfig_opts.lsp_opts.capabilities,
			},
		}
	end,
}
