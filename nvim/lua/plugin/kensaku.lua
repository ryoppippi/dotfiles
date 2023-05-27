return {
	"lambdalisue/kensaku.vim",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function()
		require("denops-lazy").load("kensaku.vim")
	end,
}
