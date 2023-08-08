return {
	"vim-denops/denops.vim",
	dependencies = {
		{
			"yuki-yano/denops-lazy.nvim",
			opts = {
				wait_load = false,
			},
		},
	},
	event = { "VeryLazy" },
	priority = 1000,
}
