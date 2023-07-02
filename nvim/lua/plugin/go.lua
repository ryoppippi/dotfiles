return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		init = function()
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").gofmt()
				end,
			})
		end,
		ft = { "go", "gomod" },
		event = { "CmdlineEnter" },
		build = ':lua require("go.install").update_all_sync()',
		opts = function()
			local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()
			return {
				capabilities = lspconfig_opts.capabilities,
				luasnip = true,
				lsp_inlay_hints = {
					enable = true,
				},
			}
		end,
		config = function(_, opts)
			require("go").setup(opts)
			require("lspconfig").gopls.setup(require("go.lsp").config())
		end,
	},

	{
		"jose-elias-alvarez/null-ls.nvim",
		opts = function(_, opts)
			if require("core.plugin").has("go.nvim") then
				local null_ls = require("null-ls")

				table.insert(opts.sources, null_ls.builtins.diagnostics.revive)
				table.insert(
					opts.sources,
					null_ls.builtins.formatting.golines.with({
						extra_args = {
							"--max-len=180",
							"--base-formatter=gofumpt",
						},
					})
				)

				-- for go.nvim
				local gotest = require("go.null_ls").gotest()
				local gotest_codeaction = require("go.null_ls").gotest_action()
				local golangci_lint = require("go.null_ls").golangci_lint()
				table.insert(opts.sources, gotest)
				table.insert(opts.sources, gotest_codeaction)
				table.insert(opts.sources, golangci_lint)
			end
		end,
	},
}
