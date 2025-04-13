---@type LazySpec
return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-telescope/telescope.nvim",
	},
	keys = {
		{ "cc", "CodeCompanion", mode = "ca" },
		{ "ccc", "CodeCompanionChat", mode = "ca" },
		{ "cca", "CodeCompanionAction", mode = "ca" },
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
			copilot = function()
				return require("codecompanion.adapters").extend("copilot", {
					schema = {
						model = {
							default = "gemini-2.5-pro",
						},
					},
				})
			end,
		},
		strategies = {
			chat = {
				adapter = "copilot",
				send = {
					modes = { n = "<C-s>", i = "<C-s>" },
				},
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
		require("codecompanion").setup(opts)
	end,
}
