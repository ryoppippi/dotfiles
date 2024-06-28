local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft

---@type LazySpec
return {
	"https://github.com/luckasRanarison/tailwind-tools.nvim",
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"tailwindcss",
	},
	opts = {},
	ft = ft.html_like,
}
