return {
	{
		"jose-elias-alvarez/typescript.nvim",
		dependencies = {
			"neovim/nvim-lspconfig",
		},
		enabled = true,
		config = function()
			local lspconfig = require("lspconfig")
			local opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()

			require("typescript").setup({
				server = {
					on_attach = function(client, buffer)
						vim.keymap.set("n", "<leader>to", function()
							vim.cmd("TypescriptAddMissingImports!")
							vim.cmd("TypescriptRemoveUnused!")
							vim.cmd("TypescriptOrganizeImports!")
						end, { desc = "Organize imports", buffer = buffer })
						vim.keymap.set("n", "<leader>tr", "<Cmd>TypescriptRenameFile<CR>", { buffer = buffer })

						opts.disable_formatting(client, buffer)
					end,
					capabilities = opts.capabilities,
					root_dir = lspconfig.util.root_pattern(opts.node_root_dir),
					single_file_support = false,
					settings = {
						javascript = {
							inlayHints = {
								includeInlayEnumMemberValueHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayParameterNameHints = "literals", -- 'none' | 'literals' | 'all';
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayVariableTypeHints = true,
							},
						},
						typescript = {
							inlayHints = {
								includeInlayEnumMemberValueHints = true,
								includeInlayFunctionLikeReturnTypeHints = true,
								includeInlayFunctionParameterTypeHints = true,
								includeInlayParameterNameHints = "literals", -- 'none' | 'literals' | 'all';
								includeInlayParameterNameHintsWhenArgumentMatchesName = true,
								includeInlayPropertyDeclarationTypeHints = true,
								includeInlayVariableTypeHints = true,
							},
						},
					},
				},
				debug = false,
				disable_commands = false,
			})
			return opts
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
