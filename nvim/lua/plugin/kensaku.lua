return {
	"lambdalisue/vim-kensaku",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function()
		require("denops-lazy").load("vim-kensaku")
	end,
}
