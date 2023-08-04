return {
	"williamboman/mason.nvim",
	cond = not is_vscode(),
	cmd = { "Mason" },
	opts = {
		ui = {
			icons = {
				package_installed = "✓",
				package_pending = "➜",
				package_uninstalled = "✗",
			},
		},
	},
}
