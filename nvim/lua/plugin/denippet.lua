local has = require("core.plugin").has

---@type LazySpec
return {
	"https://github.com/uga-rosa/denippet.vim",
	cond = not is_vscode(),
	event = { "InsertEnter" },
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
	},
	config = function()
		require("denops-lazy").load("denippet.vim")

		local Path = require("plenary.path")

		local denippet = vimx.fn.denippet
		local load = denippet.load

		vim.g.denippet_drop_on_zero = true
	end,
}
