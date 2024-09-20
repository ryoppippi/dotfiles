return {
	"thinca/vim-quickrun",
	cmd = "QuickRun",
	dependencies = {
		{ "tani/vim-artemis" },
		{ "lambdalisue/vim-quickrun-neovim-job" },
	},
	config = function()
		vimx.g.quickrun_config = {
			python = { command = "python3" },
		}
	end,
}
