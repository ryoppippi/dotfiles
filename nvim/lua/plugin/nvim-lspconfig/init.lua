local utils = require("core.utils")
local lsp_utils = require("plugin.nvim-lspconfig.utils")
local has_cmp = lsp_utils.has_cmp

---@type LazySpec[]
return {
	{ import = "plugin.nvim-lspconfig.servers" },
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "VeryLazy" },
		cond = not is_vscode(),
		dependencies = {
			"folke/neoconf.nvim",
			"b0o/schemastore.nvim",
			"kyoh86/climbdir.nvim",
			{ "hrsh7th/cmp-nvim-lsp", cond = has_cmp },
			{ "hrsh7th/cmp-nvim-lsp-document-symbol", cond = has_cmp },
			{ "hrsh7th/cmp-nvim-lsp-signature-help", cond = has_cmp, enabled = false },
		},
		init = function()
			require("core.plugin").on_attach(function(client, bufnr)
				local exclude_ft = { "oil" }
				local ft = vim.bo.filetype
				if vim.tbl_contains(exclude_ft, ft) then
					return
				end

				local on_attach = require("plugin.nvim-lspconfig.on_attach")
				on_attach(client, bufnr)

				vim.bo.omnifunc = "v:lua.vim.lsp.omnifunc"
			end)

			-- local ok, wf = pcall(require, "vim.lsp._watchfiles")
			-- if ok then
			-- 	-- disable lsp watcher. Too slow on linux
			-- 	wf._watchfunc = function()
			-- 		return function() end
			-- 	end
			-- end
		end,
	},
}
