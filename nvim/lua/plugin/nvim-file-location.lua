return {
	"diegoulloao/nvim-file-location",
	keys = {
		{
			"<leader>L",
			function()
				require("nvim-file-location").copy_file_location("absolute", true, false)
			end,
			mode = { "n" },
			desc = "Copy absolute path to clipboard",
		},
	},
	opts = {
		keymap = nil,
		mode = "absolute", -- options: workdir | absolute
		add_line = true,
		add_column = false,
	},
}
