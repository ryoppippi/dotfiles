return {
	"pwntester/octo.nvim",
	cond = not is_vscode(),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	config = true,
	cmd = "Octo",
}
