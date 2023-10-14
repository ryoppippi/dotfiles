return {
	"monaqa/nvim-treesitter-clipping",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"thinca/vim-partedit",
	},
	keys = {
		{
			"<leader>c",
			"<Plug>(ts-clipping-clip)",
			desc = "Clip",
			mode = { "n" },
		},
		{
			"<leader>c",
			"<Plug>(ts-clipping-select)",
			desc = "Clip Select",
			mode = { "x", "o" },
		},
	},
}
