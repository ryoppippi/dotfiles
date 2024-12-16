local lsp_utils = require("plugin.nvim-lspconfig.utils")
local setup = lsp_utils.setup
local format_config = lsp_utils.format_config

---@type LazySpec
return {
	name = "svelte",
	dir = ".",
	cond = not is_vscode(),
	dependencies = {
		"neovim/nvim-lspconfig",
		"node_servers",
	},
	ft = function(spec)
		return lsp_utils.get_default_filetypes(spec.name)
	end,
	opts = function()
		return {
			on_attach = function(client, _)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
					end,
				})
				format_config(false)(client)
			end,
			settings = {
				typescript = {
					inlayHints = lsp_utils.typescriptInlayHints,
				},
			},
		}
	end,
	config = function(spec, opts)
		setup(spec.name, opts)
	end,
}
