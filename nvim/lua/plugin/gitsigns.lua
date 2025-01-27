---@type LazySpec
return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost" },
		cmd = { "Gitsigns" },
		keys = {
			{ "ms", "Gitsigns", mode = "ca" },
			{ "mS", "Gitsigns stage_buffer", mode = "n" },
			{ "mh", "Gmitsigns preview_hunk", mode = "n" },
			{ "ms", "Gmitsigns stage_hunk", mode = "n" },
			{ "mu", "Gmitsigns undo_stage_hunk", mode = "n" },
			{ "mr", "Gmitsigns reset_hunk", mode = "n" },
			{ "mp", "Gmitsigns preview_hunk", mode = "n" },
			{ "mR", "Gmitsigns reset_buffer", mode = "n" },
			{ "md", "Gmitsigns diffthis split=rightbelow", mode = "n" },
			{ "mB", "Gmitsigns blame", mode = "n" },
			{ "mb", "Gmitsigns blame_line", mode = "n" },
		},
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
