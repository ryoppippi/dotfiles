return {
	"williamboman/mason.nvim",
	cond = not is_vscode(),
	enabled = true,
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
