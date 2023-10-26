return {
	"stevearc/dressing.nvim",
	cond = not is_vscode(),
	dependencies = {
		"nvim-telescope/telescope.nvim",
	},
	event = { "VeryLazy" },
	opts = function()
		return {
			select = {
				telescope = require("telescope.themes").get_cursor({ initial_mode = "normal" }),
			},
		}
	end,
}
