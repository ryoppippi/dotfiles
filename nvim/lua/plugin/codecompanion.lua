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
		adapters = {
			ollama = function()
				return require("codecompanion.adapters").extend("ollama", {
					schema = {
						name = "qwen2.5-coder",
						model = {
							default = "qwen2.5-coder:latest",
						},
					},
				})
			end,
		},
		strategies = {
			chat = {
				adapter = "ollama",
			},
			inline = {
				adapter = "ollama",
			},
			agent = {
				adapter = "ollama",
			},
		},
	},
	config = function(_, opts)
		vim.keymap.set("ca", "cc", "CodeCompanion")

		require("codecompanion").setup(opts)
	end,
}
