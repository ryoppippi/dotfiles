return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	cond = tb(vim.fn.has("nvim-0.10")),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<Leader>m",
			function()
				require("dropbar.api").pick()
			end,
		},
	},
	config = true,
}
