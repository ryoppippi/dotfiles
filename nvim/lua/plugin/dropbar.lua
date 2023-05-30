return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	cond = tb(vim.fn.has("nvim-0.10")),
	enabled = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = true,
}
