return {
	"mattn/vim-sonictemplate",
	cmd = { "Template" },
	init = function()
		vim.g.sonictemplate_key = 0
		vim.g.sonictemplate_intelligent_key = 0
		vim.g.sonictemplate_postfix_key = 0

		vim.g.sonictemplate_vim_template_dir = { vim.fn.expand(vim.fn.stdpath("config") .. "/template") }
	end,
}
