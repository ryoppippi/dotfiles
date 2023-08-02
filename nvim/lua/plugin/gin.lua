return {
	"lambdalisue/gin.vim",
	event = "VeryLazy",
	dependencies = { "vim-denops/denops.vim" },
	config = function()
		require("denops-lazy").load("gin.vim")
	end,
}
