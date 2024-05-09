return {
	"lambdalisue/vim-gin",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function()
		require("denops-lazy").load("vim-gin")
	end,
}
