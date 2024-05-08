return {
	"shortcuts/no-neck-pain.nvim",
	version = "*",
	event = "UiEnter",
	keys = {
		{ "<leader>n", "<CMD>NoNeckPain<CR>" },
	},
	opts = {
		width = 150,
		autocmds = {
			enableOnVimEnter = true,
		},
	},
	config = true,
}
