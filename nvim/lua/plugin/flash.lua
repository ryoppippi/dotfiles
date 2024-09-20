---@type LazySpec
return {
	"https://github.com/folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {},
	keys = {
		{
			"<CR>",
			mode = { "n", "x", "o", "v" },
			function()
				require("flash").jump({
					labels = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz1234567890!@#$%^&*()[]`'=-{}~"+_]],
					label = { before = true, after = false },
					-- TODO: kensaku integration
				})
			end,
			desc = "Flash",
		},
	},
}
