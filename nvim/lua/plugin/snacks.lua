---@type LazySpec
return {
	"folke/snacks.nvim",
	priority = 1000,
	event = "VeryLazy",
	---@type snacks.Config
	opts = {
		input = {
			enabled = true,
		},
		picker = {
			ui_select = true,
		},
	},
}
