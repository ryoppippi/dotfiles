return {
	"lambdalisue/gin.vim",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function()
		require("denops-lazy").load("gin.vim")
	end,
}
