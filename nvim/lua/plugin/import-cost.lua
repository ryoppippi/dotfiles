return {
	"barrett-ruth/import-cost.nvim",
	build = "sh install.sh bun",
	enabled = false,
	cond = not is_vscode(),
	ft = {
		"javascript",
		"javascriptreact",
		"typescript",
		"typescriptreact",
		"vue",
		"svelte",
	},
	config = function()
		require("import-cost").setup({
			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
			},
		})
	end,
}
