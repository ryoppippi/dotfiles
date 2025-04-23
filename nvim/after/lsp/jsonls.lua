local lsp_utils = require("plugin.nvim-lspconfig.utils")
local format_config = lsp_utils.format_config

return {
	on_attach = format_config(false),
	filetypes = { "json", "jsonc", "json5" },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
			format = { enable = true },
		},
	},
}
