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
			on_attach = function(buffer)
				local opts = { silent = true, buffer = buffer }
				vim.keymap.set("n", "<leader>gg", "<cmd>Gitsigns<cr>", opts)
				vim.keymap.set("n", "<leader>gS", "<cmd>Gitsigns stage_buffer<cr>", opts)
				vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", opts)
				vim.keymap.set("n", "<leader>gs", "<cmd>Gitsigns stage_hunk<cr>", opts)
				vim.keymap.set("n", "<leader>gu", "<cmd>Gitsigns undo_stage_hunk<cr>", opts)
				vim.keymap.set("n", "<leader>gr", "<cmd>Gitsigns reset_hunk<cr>", opts)
				vim.keymap.set("n", "<leader>gR", "<cmd>Gitsigns reset_buffer<cr>", opts)
				-- vim.keymap.set({ "o", "x" }, "ih", "<cmd><c-u>Gitsigns select_hunk<cr>", opts)
				vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis split=rightbelow<cr>", opts)
				-- vim.keymap.set("n", "<leader>gm", "<cmd>Gitsigns blame_line<cr>", opts)
			end,
		},
		config = true,
	},
}
