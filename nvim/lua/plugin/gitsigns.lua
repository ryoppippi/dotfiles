---@type LazySpec
return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost" },
		cmd = { "Gitsigns" },
		dependencies = {
			"tpope/vim-repeat",
		},
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~_" },
			},
			current_line_blame = true,
		},
		config = true,
	},
}
