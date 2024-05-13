---@type LazySpec
return {
	"ryoppippi/bad-apple.vim",
	event = { "User DenopsReady" },
	branch = "main",
	cmd = "BadApple",
	dependencies = { "vim-denops/denops.vim" },
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
