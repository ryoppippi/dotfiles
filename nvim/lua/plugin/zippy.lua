return {
	"PatschD/zippy.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"SmiteshP/nvim-navic",
	},
	init = function()
		vim.api.nvim_create_user_command("ZippyInsertPrint", function()
			require("zippy").insert_print()
		end, { nargs = 0 })
	end,
}
