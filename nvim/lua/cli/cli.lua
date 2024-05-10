---@type LazySpec[]
return {
	name = "cli",
	dir = "",
	dependencies = {
		"nvim-lua/plenary.nvim",

		--- python
		{
			name = "rye-tools",
			dir = "",
			opts = {
				tools = {
					"ruff",
					"ruff-lsp",
					"black",
					"pyright",
					"mypy",
				},
			},
			config = function(_, opts)
				vim.schedule(function()
					vim.iter(opts.tools):map(_l("x: vim.system({ 'rye', 'install', '-f', x }, { text = true })"))
				end)
			end,
		},
	},
}
