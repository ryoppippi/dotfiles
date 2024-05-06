local has = require("core.plugin").has

return {
	"L3MON4D3/LuaSnip",
	cond = not is_vscode(),
	enabled = false,
	event = { "InsertEnter" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"tpope/vim-repeat",
		{
			"benfowler/telescope-luasnip.nvim",
			init = function()
				require("plugin.telescope").le("luasnip")
			end,
		},
		{
			"saadparwaiz1/cmp_luasnip",
			cond = function()
				return has("nvim-cmp")
			end,
		},
		"ryoppippi-snippets-list",
	},
	config = function()
		local Path = require("plenary.path")

		require("luasnip")
		require("luasnip.loaders.from_snipmate").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load()
		require("luasnip.loaders.from_vscode").lazy_load({
			paths = {
				Path:new(vim.fn.stdpath("config"), "my_vscode_snippets"):absolute(),
			},
		})
	end,
}
