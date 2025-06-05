---@type LazySpec
return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for git operations
	},
	cmd = {
		"ClaudeCode",
		"ClaudeCodeResume",
		"ClaudeCodeContinue",
		"ClaudeCodeVerbose",
	},
	keys = {
		{ "cl", "ClaudeCode", mode = "ca" },
	},
	config = function()
		require("claude-code").setup()
	end,
}
