local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft
local setup = lsp_utils.setup

local filetypes = vim.iter({
	{
		"lua",
		"python",
		"go",
		"rust",
		"swift",
	},
	{ "dockerfile" },
	ft.config_like,
	ft.sh_like,
	ft.html_like,
	ft.css_like,
	ft.markdown_like,
})
	:flatten()
	:totable()

---@type LazySpec
return {
	name = "efm",
	dir = "",
	dependencies = { "neovim/nvim-lspconfig" },
	ft = filetypes,
	opts = {
		filetypes = filetypes,
		init_options = {
			documentFormatting = true,
			rangeFormatting = true,
			hover = true,
			documentSymbol = true,
			codeAction = true,
			completion = true,
		},
	},
	config = function(spec, opts)
		setup(spec.name, opts)
	end,
}
