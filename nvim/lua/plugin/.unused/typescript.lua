return {
	{
		"jose-elias-alvarez/typescript.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		enabled = false,
		opts = function()
			local lspconfig = require("lspconfig")
			local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]

			local tih = lspconfig_opts.typescriptInlayHints
			local inlayHints = {
				includeInlayEnumMemberValueHints = tih.enumMemberValues.enabled,
				includeInlayFunctionLikeReturnTypeHints = tih.functionLikeReturnTypes.enabled,
				includeInlayFunctionParameterTypeHints = tih.parameterTypes.enabled,
				includeInlayParameterNameHints = tih.parameterNames.enabled,
				includeInlayParameterNameHintsWhenArgumentMatchesName = tih.parameterNames.suppressWhenArgumentMatchesName,
				includeInlayPropertyDeclarationTypeHints = tih.propertyDeclarationTypes.enabled,
				includeInlayVariableTypeHints = tih.variableTypes.enabled,
			}

			local settings = {
				typescript = { inlayHints = inlayHints },
				javascript = { inlayHints = inlayHints },
			}
			return {
				server = {
					on_attach = function(client, buffer)
						vim.keymap.set("n", "<leader>to", function()
							vim.cmd("TypescriptAddMissingImports!")
							vim.cmd("TypescriptRemoveUnused!")
							-- vim.cmd("TypescriptOrganizeImports!")
						end, { desc = "Manage imports", buffer = buffer })
						vim.keymap.set("n", "<leader>tr", "<Cmd>TypescriptRenameFile<CR>", { buffer = buffer })
						lspconfig_opts.format_config(false)(client)
					end,
					capabilities = lspconfig_opts.lsp_opts.capabilities,
					root_dir = lspconfig.util.root_pattern(lspconfig_opts.node_root_dir),
					single_file_support = false,
					settings = settings,
				},
				debug = false,
				disable_commands = false,
			}
		end,
		config = function(_, opts)
			require("typescript").setup(opts)
		end,
	},
	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			if require("core.plugin").has("typescript.nvim") then
				table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
			end
		end,
	},
}
