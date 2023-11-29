return {
	"mattn/vim-sonictemplate",
	cmd = { "Template" },
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		vim.g.sonictemplate_key = 0
		vim.g.sonictemplate_intelligent_key = 0
		vim.g.sonictemplate_postfix_key = 0
		vim.g.sonictemplate_vim_vars = {
			_ = {
				author = 'Ryotaro "Justin" Kimura',
			},
		}

		local Path = require("plenary.path")
		vim.g.sonictemplate_vim_template_dir = {
			Path:new(vim.fn.stdpath("config"), "template"):absolute(),
		}
	end,
}
