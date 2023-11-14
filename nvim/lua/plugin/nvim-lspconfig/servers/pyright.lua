return {
	name = "@lsp/pyright",
	dir = "",
	ft = "python",
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "microsoft/pyright", version = "1.*", build = { "rye install pyright -f" } },
	},
	config = function()
		local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
		local setup = lspconfig_opts.setup

		setup("pyright", { before_init = require("plugin.nvim-lspconfig.util").python_lsp_init })
	end,
}
