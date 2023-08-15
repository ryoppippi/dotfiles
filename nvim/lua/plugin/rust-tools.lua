return {
	"simrat39/rust-tools.nvim",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	cond = not is_vscode(),
	event = {
		"BufReadPre *.rs",
		"BufNewFile *.rs",
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
