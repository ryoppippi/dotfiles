---@type LazySpec
return {
	"ryoppippi/vim-cord",
	enabled = false,
	dev = true,
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function(spec)
		require("denops-lazy").load(spec.name)
		require("vim-cord").setup()
	end,
}
