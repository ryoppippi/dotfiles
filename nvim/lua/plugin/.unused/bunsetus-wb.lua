return {
	enabled = false,
	dir = "~/ghq/github.com/ryoppippi/bunsetsu-wb.vim",
	dependencies = {
		{ dir = "~/ghq/github.com/ryoppippi/bunsetsu.vim" },
		{ "vim-denops/denops.vim" },
		{ "yuki-yano/denops-lazy.nvim" },
		{ "echasnovski/mini.ai", version = "*" },
	},
	lazy = false, --おはよう;w
	keys = {
		{
			"w",
			function()
				require("bunsetsu_wb").w()
			end,
			{ "n" },
		},
		{
			"e",
			function()
				require("bunsetsu_wb").e()
			end,
			{ "n" },
		},
		{
			"b",
			function()
				require("bunsetsu_wb").b()
			end,
			{ "n" },
		},
	},
	init = function()
		require("mini.ai").setup({
			custom_textobjects = {
				["w"] = function()
					local CWORD = require("bunsetsu_wb").getCWORD()
					local line = vim.fn.line(".")
					return { from = { line = line, col = CWORD.col }, to = { line = line, col = CWORD.colend } }
				end,
			},
		})
	end,
}
