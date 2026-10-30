---@type LazySpec
return {
	"https://github.com/stevearc/quicker.nvim",
	ft = { "qf" },
	keys = {
		{
			"<leader>R",
			function()
				require("quicker").refresh()
			end,
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("BufReadPost", {
			pattern = "qf",
			once = true,
			callback = function()
				local refresh = require("quicker").refresh

				refresh()
			end,
		})
	end,
	---@module "quicker"
	---@type quicker.SetupOptions
	opts = {},
}
