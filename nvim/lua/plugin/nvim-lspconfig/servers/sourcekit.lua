local lsp_utils = require("plugin.nvim-lspconfig.utils")
local setup = lsp_utils.setup

---@type LazySpec
return {
	{
		name = "sourcekit",
		dir = "",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		ft = function(spec)
			return lsp_utils.get_default_filetypes(spec.name)
		end,
		config = function()
			setup(
				"sourcekit",
				{
					capabilities = {
						workspace = {
							didChangeWatchedFiles = {
								dynamicRegistration = true,
							},
						},
					},
				}
			)
		end,
	},
}
