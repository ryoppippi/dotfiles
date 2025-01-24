---@type LazySpec
return {
	"lambdalisue/vim-gin",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	keys = {
		{ "gp", "Gin push", mode = "ca" },
		{ "gpl", "Gin pull", mode = "ca" },
	},
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
