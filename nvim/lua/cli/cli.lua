---@type LazySpec[]
return {
	name = "cli",
	dir = vim.env.TMPDIR .. "/cli",
	dependencies = {
		"nvim-lua/plenary.nvim",

		--- python
		{
			name = "rye-tools",
			dir = vim.env.TMPDIR .. "/cli-rye-tools",
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
