---@type LazySpec
return {
	"lambdalisue/vim-gin",
	event = { "User DenopsReady" },
	dependencies = {
		{ "vim-denops/denops.vim" },
		{ "tani/vim-artemis" },
	},
	keys = {
		{ "gp", "Gin push", mode = "ca" },
		{ "gpl", "Gin pull", mode = "ca" },
		{ "gc", "Gin commit", mode = "ca" },
		{ "gb", "GinBrowse", mode = "ca" },
	},
	config = function(spec)
		vimx.g.gin_browse_default_args = { "-n", "--permalink" }
		vimx.g.gin_browse_persistent_args = { "++yank" }
		require("denops-lazy").load(spec.name)
	end,
}
