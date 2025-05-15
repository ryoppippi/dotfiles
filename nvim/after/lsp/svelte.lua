local lsp_utils = require("plugin.nvim-lspconfig.utils")

---@type vim.lsp.Config
return {
	on_attach = function(client, _)
		vim.api.nvim_create_autocmd("BufWritePost", {
			pattern = { "*.js", "*.ts" },
			callback = function(ctx)
				client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
			end,
		})
	end,
	single_file_support = true,
	settings = {
		format = {
			enable = false,
		},
		typescript = {
			inlayHints = lsp_utils.typescriptInlayHints,
		},
	},
}
