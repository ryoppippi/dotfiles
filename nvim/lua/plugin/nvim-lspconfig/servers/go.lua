local lsp_utils = require("plugin.nvim-lspconfig.utils")

---@type LazySpec
return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua",
			"nvim-treesitter/nvim-treesitter",
			"neovim/nvim-lspconfig",
		},
		ft = function()
			return lsp_utils.get_default_filetypes("gopls")
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
			return {
				luasnip = false,
				lsp_inlay_hints = {
					enable = true,
				},
				lsp_keymaps = false,
			}
		end,
		config = function(_, opts)
			require("go").setup(opts)
			require("lspconfig").gopls.setup(require("go.lsp").config())
		end,
	},
}
