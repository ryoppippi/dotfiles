return {
	"jay-babu/mason-null-ls.nvim",
	cond = not is_vscode(),
	dependencies = {
		"williamboman/mason.nvim",
	},
	opts = {
		ensure_installed = { "stylua", "hadolint" },
	},
}
