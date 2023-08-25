return {
	"vim-denops/denops.vim",
	lazy = false,
	dependencies = {
		{
			"yuki-yano/denops-lazy.nvim",
			opts = {
				wait_load = false,
			},
		},
	},
	priority = 1000,
}
