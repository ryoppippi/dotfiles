---@type LazySpec
return {
	"vyfor/cord.nvim",
	build = ":Cord update",
	event = "VeryLazy",
	opts = {
		workspace_blacklist = {},
	}, -- calls require('cord').setup()
}
