local lsp_utils = require("plugin.nvim-lspconfig.utils")
local format_config = lsp_utils.format_config

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
