---@type LazySpec
return {
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	event = { "LspAttach" },
	keys = {
		{
			"<Leader>l",
			function()
				require("tiny-inline-diagnostic").toggle()
			end,
			mode = { "n", "v" },
			desc = "Toggle tiny_lsp",
		},
	},
	opts = {
		options = {
			show_source = true,
		},
	},
	config = function(_, opts)
		vim.diagnostic.config({ virtual_text = false })
		require("tiny-inline-diagnostic").setup(opts)
	end,
}
