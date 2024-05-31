---@type LazySpec
return {
	"https://github.com/lambdalisue/vim-deno-cache",
	name = "deno-cache",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
