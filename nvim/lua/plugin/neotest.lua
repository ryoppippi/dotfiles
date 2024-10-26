---@type LazySpec
return {
	"https://github.com/nvim-neotest/neotest",
	cmd = { "Neotest" },
	dependencies = {
		{
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		"https://github.com/marilari88/neotest-vitest",
	},
	opts = function()
		return {
			adapters = {
				require("neotest-vitest"),
			},
		}
	end,
}
