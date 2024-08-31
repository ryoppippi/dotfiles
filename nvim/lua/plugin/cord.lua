---@type LazySpec
return {
	"vyfor/cord.nvim",
	build = " nix develop --command ./build",
	event = "VeryLazy",
	opts = {
		workspace_blacklist = {},
	}, -- calls require('cord').setup()
}
