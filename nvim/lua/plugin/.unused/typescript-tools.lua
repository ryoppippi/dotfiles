return {
	"pmizio/typescript-tools.nvim",
	cond = not is_vscode(),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	event = function()
		local return_events = {}
		local events = { "BufReadPre", "BufNewFile" }
		local exts = { "js", "jsx", "ts", "tsx" }
		for _, ext in ipairs(exts) do
			for _, event in ipairs(events) do
				table.insert(return_events, string.format("%s *.%s", event, ext))
			end
		end
		return return_events
	end,
	enabled = false,
	opts = function()
		local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
		local lsp_opts = lspconfig_opts.lsp_opts
		local tih = lspconfig_opts.typescriptInlayHints
		return {
			on_attach = function(client, buffer)
				vim.keymap.set("n", "<leader>to", function()
					vim.cmd("TSToolsRemoveUnusedImports!")
					vim.cmd("TSToolsAddMissingImports!")
					-- vim.cmd("TypescriptOrganizeImports!")
				end, { desc = "Manage imports", buffer = buffer })

				lspconfig_opts.format_config(false)(client)
			end,
			capabilities = lsp_opts.capabilities,
			settings = {
				tsserver_plugins = { "typescript-styled-plugin", "typescript-svelte-plugin" },
				tsserver_file_preferences = {
					includeInlayEnumMemberValueHints = tih.enumMemberValues.enabled,
					includeInlayFunctionLikeReturnTypeHints = tih.functionLikeReturnTypes.enabled,
					includeInlayFunctionParameterTypeHints = tih.parameterTypes.enabled,
					includeInlayParameterNameHints = tih.parameterNames.enabled,
					includeInlayParameterNameHintsWhenArgumentMatchesName = tih.parameterNames.suppressWhenArgumentMatchesName,
					includeInlayPropertyDeclarationTypeHints = tih.propertyDeclarationTypes.enabled,
					includeInlayVariableTypeHints = tih.variableTypes.enabled,
				},
			},
			tsserver_format_options = {
				allowRenameOfImportPath = false,
			},
		}
	end,
}
