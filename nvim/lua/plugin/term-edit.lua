return {
	"chomosuke/term-edit.nvim",
	lazy = false,
	version = "1.*",
	opts = {
		prompt_end = "❯ ",
		mapping = {
			n = {
				["<C-i>"] = false,
			},
		},
	},
	config = true,
}
