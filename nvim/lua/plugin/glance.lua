return {
	"dnlhc/glance.nvim",
	cmd = { "Glance" },
	opts = function()
		local glance = require("glance")
		return {
			border = { enable = true },
			list = { position = "left" },
			folds = { folded = false },
			mappings = {
				list = {
					["<C-s>"] = glance.actions.jump_split,
					["<C-v>"] = glance.actions.jump_vsplit,
				},
			},
		}
	end,
	config = true,
}
