---@type LazySpec
return {
	"https://github.com/lambdalisue/vim-fall",
	name = "fall",
	event = { "User DenopsReady" },
	cmd = "Fall",
	dependencies = {
		"vim-denops/denops.vim",
	},
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
