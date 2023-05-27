return {
	"stevearc/dressing.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	event = "VeryLazy",
	opts = {
		select = {
			telescope = require("telescope.themes").get_cursor({ initial_mode = "normal" }),
		},
	},
}
