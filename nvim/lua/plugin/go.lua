return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		event = function()
			local return_events = {}
			local events = { "BufReadPre", "BufNewFile" }
			local exts = { "go", "gomod" }
			for _, ext in ipairs(exts) do
				for _, event in ipairs(events) do
					table.insert(return_events, string.format("%s *.%s", event, ext))
				end
			end
			return return_events
		end,
		cond = not is_vscode(),
		build = ':lua require("go.install").update_all_sync()',
		init = function()
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*.go",
				callback = function()
					require("go.format").gofmt()
				end,
			})
		end,
		opts = function()
			local lspconfig_opts = (
				require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
			)
			return {
				capabilities = lspconfig_opts.lsp_opts.capabilities,
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
}
