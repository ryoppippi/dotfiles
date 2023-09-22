return {
	"ryoppippi/bad-apple.vim",
	event = { "User DenopsReady" },
	branch = "main",
	cmd = "BadApple",
	dependencies = { "vim-denops/denops.vim" },
	config = function()
		require("denops-lazy").load("bad-apple.vim")
	end,
}
