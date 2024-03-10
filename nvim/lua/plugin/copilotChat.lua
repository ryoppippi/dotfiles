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
		-- prompts = {
		-- 	Explain = {
		-- prompt = "/COPILOT_EXPLAIN 上のコードの説明を段落として書きなさい。",
		-- 	},
		-- },
	},
	-- See Commands section for default commands if you want to lazy load on them
}
