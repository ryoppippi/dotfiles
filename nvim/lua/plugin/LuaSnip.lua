local has = require("core.plugin").has

return {
	"L3MON4D3/LuaSnip",
	cond = not is_vscode(),
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

		-- {{ snippets
		"craigmac/vim-vsnip-snippets",
		"honza/vim-snippets",
		"rafamadriz/friendly-snippets",

		-- language specific snippets
		-- python
		"cstrap/flask-snippets",
		"cstrap/python-snippets",
		-- zig
		"Metalymph/zig-snippets",
		-- web
		"fivethree-team/vscode-svelte-snippets",
		"xabikos/vscode-javascript",
		-- }}
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
