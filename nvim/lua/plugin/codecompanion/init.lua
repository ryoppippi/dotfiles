---@type LazySpec
return {
	"olimorris/codecompanion.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/codecompanion-history.nvim",
	},
	keys = {
		{ "cc", "CodeCompanion", mode = "ca" },
		{ "ccc", "CodeCompanionChat", mode = "ca" },
		{ "cca", "CodeCompanionAction", mode = "ca" },
	},
	opts = {
		adapters = {
			acp = {
				claude_code = function()
					return require("codecompanion.adapters").extend("claude_code", {
						env = {
							CLAUDE_CODE_OAUTH_TOKEN = "my-oauth-token",
						},
					})
				end,
			},
			http = {
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
								default = "gpt-5",
							},
						},
					})
				end,
			},
		},
		strategies = {
			chat = {
				adapter = "copilot",
				keymaps = {
					send = {
						modes = { n = "<C-s>", i = "<C-s>" },
						index = 1,
						callback = function(chat)
							vim.cmd("stopinsert")
							chat:add_buf_message({ role = "llm", content = "" })
							chat:submit()
						end,
					},
				},
			},
			inline = {
				adapter = "copilot",
			},
			agent = {
				adapter = "copilot",
			},
		},
		extensions = {
			history = {
				enabled = true,
			},
		},
	},
	config = function(_, opts)
		require("codecompanion").setup(opts)
	end,
	init = function()
		require("plugin.codecompanion.spinner"):init()
	end,
}
