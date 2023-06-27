return {
	"yioneko/nvim-vtsls",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	enabled = false,
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()

		require("lspconfig.configs").vtsls = require("vtsls").lspconfig
		require("lspconfig.configs")
		require("lspconfig").vtsls.setup({
			capabilities = opts.capabilities,
			single_file_support = false,
			settings = {
				typescript = {
					suggest = {
						completionFunctionCalls = true,
					},
					inlayHints = opts.typescriptInlayHints,
					tsserver = {
						pluginPaths = { "." },
					},
				},
				javascript = {
					inlayHints = opts.typescriptInlayHints,
				},
			},
		})
	end,
}
