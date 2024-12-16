local lsp_utils = require("plugin.nvim-lspconfig.utils")
local setup = lsp_utils.setup

---@type LazySpec
return {
	{
		name = "sourcekit",
		dir = ".",
		cond = not is_vscode(),
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		ft = function(spec)
			return lsp_utils.get_default_filetypes(spec.name)
		end,
		config = function(spec)
			setup(spec.name, {
				capabilities = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},
			})
		end,
	},
}
