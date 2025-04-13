---@type LazySpec
return {
	"CopilotC-Nvim/CopilotChat.nvim",
	event = "VeryLazy",
	build = "make tiktoken",
	keys = {
		{ "cpc", "CopilotChat", mode = "ca" },
	},
	dependencies = {
		"zbirenbaum/copilot.lua", -- or github/copilot.vim
		"nvim-lua/plenary.nvim", -- for curl, log wrapper
	},
	opts = {
		debug = false, -- Enable debugging
		chat_autocomplete = true,
		model = "gemini-2.5-pro",
	},
	-- See Commands section for default commands if you want to lazy load on them
}
