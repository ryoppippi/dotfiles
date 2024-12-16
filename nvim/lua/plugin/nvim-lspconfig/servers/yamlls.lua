local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft
local setup = lsp_utils.setup

local filetypes = ft.yaml_like

---@type LazySpec
return {
	name = "yamlls",
	dir = ".",
	cond = not is_vscode(),
	dependencies = {
		"neovim/nvim-lspconfig",
		"b0o/schemastore.nvim",
		"node_servers",
	},
	ft = filetypes,
	opts = function()
		return {
			filetypes = filetypes,
			settings = {
				yaml = {
					schemas = require("schemastore").yaml.schemas({
						extra = {
							{
								name = "openAPI 3.0",
								url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml",
							},
							{

								name = "openAPI 3.1",
								url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.yaml",
							},
						},
					}),
					validate = true,
					format = { enable = true },
				},
			},
		}
	end,
	config = function(spec, opts)
		setup(spec.name, opts)
	end,
}
