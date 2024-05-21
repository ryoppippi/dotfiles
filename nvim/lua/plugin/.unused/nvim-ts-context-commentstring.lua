return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	enabled = false,
	init = function()
		vim.g.skip_ts_context_commentstring_module = true
	end,
	opts = {
		enable = true,
		enable_autocmd = false,
	},
}
