---@type LazySpec[]
return {
	name = "cli",
	dir = vim.env.TMPDIR .. "/cli",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
}
