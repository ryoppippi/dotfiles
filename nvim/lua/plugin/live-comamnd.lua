return {
	"smjonas/live-command.nvim",
	event = "VeryLazy",
	opts = {
		commands = {
			Norm = { cmd = "norm" },
		},
	},
	config = function(_, opt)
		require("live-command").setup(opt)
	end,
}
