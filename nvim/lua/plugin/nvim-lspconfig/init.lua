---@type LazySpec[]
return {
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		cond = not is_vscode(),
		dependencies = {
			"b0o/schemastore.nvim",
			"yioneko/nvim-vtsls",
			---@diagnostic disable-next-line: missing-fields
			{
				"ray-x/go.nvim",
				dir = vim.env.GO_NVIM, -- Nix-provided pre-built plugin
				dependencies = {
					"ray-x/guihua.lua",
					"nvim-treesitter/nvim-treesitter",
					"neovim/nvim-lspconfig",
				},
			},
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
				"gh_actions_ls",
				"nixd",

				-- web/javascript
				"svelte",
				"denols",
				"prismals",
				"astro",
				"biome",
				"eslint",
				"emmet_ls",
				"tailwindcss",
				"cssmodules_ls",
				"unocss",
				"html",
				"stylelint_lsp",
				"vtsls",

				-- go
				"gopls",

				-- lua
				"lua_ls",

				-- zig
				"zls",

				-- swift
				"sourcekit",

				-- python
				"pyright",

				-- misc
				"typos_lsp",
				"sqls",
				"clojure_lsp",
				"r_language_server",
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
