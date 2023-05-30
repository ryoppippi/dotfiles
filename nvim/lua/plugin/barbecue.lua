return {
	"utilyre/barbecue.nvim",
	version = "*",
	event = "VeryLazy",
	-- cond = not tb(vim.fn.has("nvim-0.10")),
	enabled = true,
	dependencies = {
		"SmiteshP/nvim-navic",
		"nvim-tree/nvim-web-devicons",
	},
	config = true,
	opts = {
		exclude_filetypes = { "netrw", "toggleterm", "oil", "neo-tree" },
		show_modified = true,
		attach_navic = false,
	},
}
