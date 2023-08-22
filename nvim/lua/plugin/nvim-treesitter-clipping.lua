return {
	"monaqa/nvim-treesitter-clipping",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	keys = {
		{ "<leader>c", "<Plug>(ts-clipping-clip)", { "n" } },
		{ "<leader>c", "<Plug>(ts-clipping-select)", { "x", "o" } },
	},
}
