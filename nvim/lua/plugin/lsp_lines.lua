-- TODO: replace with vim.diagnostic.config virtual_line https://github.com/neovim/neovim/pull/31959/
return {
	"https://git.sr.ht/~whynothugo/lsp_lines.nvim",
	name = "lsp_lines",
	dependencies = { "neovim/nvim-lspconfig" },
	event = { "LspAttach" },
	keys = {
		{
			"<Leader>l",
			function()
				require("lsp_lines").toggle()
			end,
			mode = { "n", "v" },
			desc = "Toggle lsp_lines",
		},
	},
	config = function(_, opts)
		require("lsp_lines").setup(opts)
		-- vim.diagnostic.config({ virtual_text = false })
	end,
}
