---@type LazySpec
return {
	{
		"Rawnly/gist.nvim",
		cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
		dependencies = {
			"samjwill/nvim-unception",
			lazy = false,
			init = function()
				vim.g.unception_block_while_host_edits = true
			end,
		},
		config = true,
	},
}
