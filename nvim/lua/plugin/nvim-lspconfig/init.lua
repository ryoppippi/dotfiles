local lsp_utils = require("plugin.nvim-lspconfig.utils")

---@type LazySpec[]
return {
	{ import = "plugin.nvim-lspconfig.servers" },
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cond = not is_vscode(),
		dependencies = {
			"folke/neoconf.nvim",
			"node_servers",
		},
		config = function()
			vim.lsp.config(
				"*",
				(function()
					local opts = {}
					opts.capabilities = vim.lsp.protocol.make_client_capabilities()
					opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
					return opts
				end)()
			)
			vim.lsp.enable({
				-- general
				"efm",

				-- config files
				"jsonls",
				"yamlls",

				-- web
				"svelte",

				-- lua
				"lua_ls",

				-- zig
				"zls",
			})
		end,

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

			vim.api.nvim_create_user_command("LspDiagnosticReset", function()
				vim.diagnostic.reset()
			end, {})

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
