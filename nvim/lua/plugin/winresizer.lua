return {
	"simeji/winresizer",
	init = function()
		vim.g.winresizer_enable = 1
	end,
	keys = {
		{ "<leader>ww", "<cmd>WinResizerStartResize<cr>", silent = true },
	},
}
