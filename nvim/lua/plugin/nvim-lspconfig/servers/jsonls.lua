local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft
local setup = lsp_utils.setup
local format_config = lsp_utils.format_config

local filetypes = ft.json_like

---@type LazySpec
return {
	name = "jsonls",
	dir = vim.env.TMPDIR .. "/lsp",
	cond = not is_vscode(),
	dependencies = {
		"neovim/nvim-lspconfig",
		"b0o/schemastore.nvim",
	},
	ft = filetypes,
	opts = function()
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
	end,
	config = function(spec, opts)
		setup(spec.name, opts)
	end,
}
