return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	config = function()
		require("which-key").setup({
			preset = "modern",
			plugins = {
				registers = false,
			},
		})
	end,
}
