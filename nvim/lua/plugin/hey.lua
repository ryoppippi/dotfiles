---@type LazySpec
return {
	"tani/hey.vim",
	dependencies = { "vim-denops/denops.vim" },
	cmd = { "Hey" },
	event = { "User DenopsReady" },
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
