return {
	"pwntester/octo.nvim",
	cond = not is_vscode(),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
		"echasnovski/mini.icons",
	},
	opts = {
		picker = "snacks",
	},
	cmd = "Octo",
}
