---@type LazySpec
return {
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost" },
		cmd = { "Gitsigns" },
		keys = {
			{ "gs", "Gitsigns", mode = "ca" },
			{ "<leader>gS", "Gitsigns stage_buffer", mode = "n" },
			{ "<leader>gh", "Gitsigns preview_hunk", mode = "n" },
			{ "<leader>gs", "Gitsigns stage_hunk", mode = "n" },
			{ "<leader>gu", "Gitsigns undo_stage_hunk", mode = "n" },
			{ "<leader>gr", "Gitsigns reset_hunk", mode = "n" },
			{ "<leader>gp", "Gitsigns preview_hunk", mode = "n" },
			{ "<leader>gR", "Gitsigns reset_buffer", mode = "n" },
			{ "<leader>gd", "Gitsigns diffthis split=rightbelow", mode = "n" },
			{ "<leader>gb", "Gitsigns blame", mode = "n" },
			{ "<leader>gm", "Gitsigns blame_line", mode = "n" },
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
