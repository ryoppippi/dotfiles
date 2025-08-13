---@type LazySpec
return {
	"coder/claudecode.nvim",
	event = "VeryLazy",
	dependencies = { "folke/snacks.nvim" },
	config = true,
	keys = {
		{ "cl", "ClaudeCode", mode = "ca" },
	},
}
