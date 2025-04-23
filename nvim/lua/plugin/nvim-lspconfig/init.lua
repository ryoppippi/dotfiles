local lsp_utils = require("plugin.nvim-lspconfig.utils")
local has_cmp = lsp_utils.has_cmp

local function load_after(plugin)
	local dir = plugin.dir .. "/after/plugin"
	local fd = vim.loop.fs_scandir(dir)
	if not fd then
		return
	end
	while true do
		local file_name, type = vim.loop.fs_scandir_next(fd)
		if not file_name then
			break
		end
		if type == "file" then
			vim.cmd.source(dir .. "/" .. file_name)
		end
	end
end

---@type LazySpec[]
return {
	{ import = "plugin.nvim-lspconfig.servers" },
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile", "VeryLazy" },
		dev = true,
		cond = not is_vscode(),
		dependencies = {
			"folke/neoconf.nvim",
			"b0o/schemastore.nvim",
			{
				"hrsh7th/cmp-nvim-lsp",
				cond = has_cmp,
				config = function(p)
					load_after(p)
				end,
			},
			{
				"hrsh7th/cmp-nvim-lsp-document-symbol",
				cond = has_cmp,
				config = function(p)
					load_after(p)
				end,
			},
			{
				"hrsh7th/cmp-nvim-lsp-signature-help",
				cond = has_cmp,
				enabled = false,
				config = function(p)
					load_after(p)
				end,
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
