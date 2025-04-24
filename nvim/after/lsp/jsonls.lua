local lsp_utils = require("plugin.nvim-lspconfig.utils")

return {
	filetypes = { "json", "jsonc", "json5" },
	settings = {
		json = {
			schemas = require("schemastore").json.schemas(),
			validate = { enable = true },
			format = { enable = true },
		},
	},
}
