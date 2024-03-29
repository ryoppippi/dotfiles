return {
	"TimUntersberger/neogit",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = true,
	cmd = { "Neogit" },
	keys = {
		{
			"<leader>g<cr>",
			function()
				require("neogit").open({})
			end,
			desc = "Open Neogit in floating window",
		},
		{
			"<leader>gc",
			function()
				require("neogit").open({ "commit" })
			end,
			desc = "Open Neogit commit window",
		},
	},
}
