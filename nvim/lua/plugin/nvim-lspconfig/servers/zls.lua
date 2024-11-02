local lsp_utils = require("plugin.nvim-lspconfig.utils")
local setup = lsp_utils.setup

---@type LazySpec
return {
	{
		name = "zls",
		dir = vim.env.TMPDIR .. "/lsp-zls",
		cond = not is_vscode(),
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		ft = function(spec)
			return lsp_utils.get_default_filetypes(spec.name)
		end,
		init = function()
			vim.g.zig_fmt_autosave = 0
		end,
		config = function(spec)
			setup(spec.name)
		end,
	},
}
