return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({
			plugins = {
				registers = false,
			},
			operators = { gc = "Comments" },
		})
	end,
}
