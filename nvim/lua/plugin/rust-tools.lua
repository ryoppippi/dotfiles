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
	config = function()
		local opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()
		require("rust-tools").setup({
			server = {
				capabilities = opts.capabilities,
			},
		})
		return opts
	end,
}
