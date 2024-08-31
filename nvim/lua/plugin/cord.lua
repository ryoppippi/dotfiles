---@type LazySpec
return {
	"vyfor/cord.nvim",
	build = " nix develop --command ./build",
	event = "VeryLazy",
	opts = {
		text = {
			-- viewing = 'Viewing {}',
			viewing = "Viewing",
			-- editing = "Editing { }",
			editing = "Editing",
			-- workspace = 'In {}',
			workspace = "",
		},
	}, -- calls require('cord').setup()
}
