---@type LazySpec
return {
	"vyfor/cord.nvim",
	build = " nix develop --command ./build",
	event = "VeryLazy",
	opts = {
		workspace_blacklist = { "~/ghq/github.com/fixpoint/" },
	}, -- calls require('cord').setup()
}
