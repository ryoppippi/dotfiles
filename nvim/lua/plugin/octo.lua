return {
	"pwntester/octo.nvim",
	cond = not is_vscode(),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"echasnovski/mini.icons",
	},
	config = true,
	cmd = "Octo",
}
