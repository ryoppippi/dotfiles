local on_load = require("core.plugin").on_load

return {
	"CopilotC-Nvim/CopilotChat.nvim",
	event = "VeryLazy",
	branch = "canary",
	dependencies = {
		{ "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
		{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
	},
	opts = {
		debug = false, -- Enable debugging
	},
	init = function()
		on_load("nvim-cmp", function()
			require("CopilotChat.integrations.cmp").setup()
		end)
	end,
	-- See Commands section for default commands if you want to lazy load on them
}
