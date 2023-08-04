return {
	"Wansmer/treesj",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	enabled = false,
	keys = {
		{
			"<leader>j",
			function()
				require("treesj").toggle({ split = { recursive = true } })
			end,
		},
	},
	opts = {
		use_default_keymaps = false,
		max_join_length = 1000000000000,
	},
}
