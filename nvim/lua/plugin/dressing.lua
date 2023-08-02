return {
	"stevearc/dressing.nvim",
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	event = { "CursorHold", "CursorMoved" },
	opts = function()
		return {
			select = {
				telescope = require("telescope.themes").get_cursor({ initial_mode = "normal" }),
			},
		}
	end,
}
