local event = { "ColorScheme", "BufReadPost" }
return {
	"uga-rosa/ccc.nvim",
	cond = vim.o.termguicolors and not is_vscode(),
	event = event,
	config = function()
		require("ccc").setup({})
		vim.api.nvim_create_autocmd(event, {
			pattern = "*",
			callback = function()
				require("ccc").setup({})
				vim.cmd([[CccHighlighterDisable]])
				vim.cmd([[CccHighlighterEnable]])
			end,
		})
	end,
}
