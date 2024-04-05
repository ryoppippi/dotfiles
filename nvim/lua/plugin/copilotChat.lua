return {
	"CopilotC-Nvim/CopilotChat.nvim",
	event = "BufReadPost",
	branch = "canary",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	opts = {
		debug = false, -- Enable debugging
	},
	-- See Commands section for default commands if you want to lazy load on them
}
