local has = require("core.plugin").has

---@type LazySpec[]
return {
	{
		"https://github.com/uga-rosa/denippet.vim",
		cond = not is_vscode(),
		event = { "InsertEnter", "User DenopsReady" },
		dependencies = {
			"vim-denops/denops.vim",
			{
				"uga-rosa/cmp-denippet",
				cond = function()
					return has("nvim-cmp")
				end,
			},
			"nvim-lua/plenary.nvim",
			"tani/vim-artemis",
			"ryoppippi-snippets-list",
			"ryoppippi/denippet-autoimport-vscode",
		},
		init = function()
			vim.g.denippet_drop_on_zero = true
		end,
		config = function()
			require("denops-lazy").load("denippet.vim")
		end,
	},
	{
		"ryoppippi/denippet-autoimport-vscode",
		event = { "InsertEnter", "User DenopsReady" },
		dependencies = {
			"vim-denops/denops.vim",
			"ryoppippi-snippets-list",
		},
		config = function()
			require("denops-lazy").load("denippet-autoimport-vscode")
		end,
	},
}
