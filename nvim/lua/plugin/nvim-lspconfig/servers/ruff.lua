return {
	name = "@lsp/ruff",
	dir = "",
	ft = { "python" },
	dependencies = {
		"neovim/nvim-lspconfig",
		{ "astral-sh/ruff-lsp", version = "*", build = { "rye install ruff-lsp -f" } },
	},
	config = function()
		local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
		local setup = lspconfig_opts.setup

		setup("ruff_lsp", { before_init = require("plugin.nvim-lspconfig.util").python_lsp_init })
	end,
}
