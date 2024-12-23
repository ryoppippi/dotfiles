---@type LazySpec
return {
	"CopilotC-Nvim/CopilotChat.nvim",
	event = "VeryLazy",
	dependencies = {
		"zbirenbaum/copilot.lua", -- or github/copilot.vim
		"nvim-lua/plenary.nvim", -- for curl, log wrapper
	},
	opts = {
		debug = false, -- Enable debugging
		chat_autocomplete = true,
	},
	-- See Commands section for default commands if you want to lazy load on them
}
