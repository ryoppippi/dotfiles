---@type LazySpec
return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
		"stevearc/dressing.nvim",
		"github/copilot.vim",
	},
	opts = {
		strategies = {
			chat = {
				adapter = "copilot",
			},
			inline = {
				adapter = "copilot",
			},
			agent = {
				adapter = "copilot",
			},
		},
	},
	config = function(_, opts)
		vim.keymap.set("ca", "cc", "CodeCompanion")

		require("codecompanion").setup(opts)
	end,
}
