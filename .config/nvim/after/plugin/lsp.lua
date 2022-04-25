local util_plug = require("utils.plugin")
if not util_plug.is_exists("lspconfig") then
	return
end
if not util_plug.is_exists("nvim-lsp-installer") then
	return
end

local function loading()
	local lsp_installer_status, lsp_installer = util_plug.force_require("nvim-lsp-installer")
	if not lsp_installer_status then
		return
	end
	local lsp_status, lspconfig = util_plug.force_require("lspconfig")
	if not lsp_status then
		return
	end

	local protocol = require("vim.lsp.protocol")

	local on_attach = function(client, bufnr)
		--Enable completion triggered by <c-x><c-o>
		local function buf_set_option(...)
			vim.api.nvim_buf_set_option(bufnr, ...)
		end

		buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

		-- Mappings.
		local opts = { noremap = true, silent = true, buffer = bufnr }

		-- See `:help vim.lsp.*` for documentation on any of the below functions
		-- vim.keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		-- vim.keymap.set('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
		-- vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
		-- vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
		-- vim.keymap.set('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
		--vim.keymap.set('i', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
		vim.keymap.set("n", "<leader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
		vim.keymap.set("n", "<leader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
		vim.keymap.set("n", "<leader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
		-- vim.keymap.set('n', '<space>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
		-- vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
		-- vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
		-- vim.keymap.set('n', '<leader>r', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
		-- vim.keymap.set("n", "-", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
		-- vim.keymap.set("n", "_", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
		-- vim.keymap.set("n", "gl", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", opts)
		vim.keymap.set("n", "<leader>z", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

		-- formatting
		if client.name == "tsserver" then
			client.resolved_capabilities.document_formatting = false
		elseif client.name == "python" then
			client.resolved_capabilities.document_formatting = false
			client.resolved_capabilities.document_range_formatting = false
		elseif client.name == "svelte" then
			client.resolved_capabilities.document_formatting = true
		elseif client.name == "eslint" then
			client.resolved_capabilities.document_formatting = true
		end

		-- if client.resolved_capabilities.document_formatting then
		local FormatAugroup = vim.api.nvim_create_augroup("Format", { clear = true })
		vim.api.nvim_create_autocmd("BufWritePre", {
			command = "lua vim.lsp.buf.formatting_seq_sync()",
			buffer = 0,
			group = FormatAugroup,
		})
		-- end

		--protocol.SymbolKind = { }
		protocol.CompletionItemKind = {
			"", -- Text
			"", -- Method
			"", -- Function
			"", -- Constructor
			"", -- Field
			"", -- Variable
			"", -- Class
			"ﰮ", -- Interface
			"", -- Module
			"", -- Property
			"", -- Unit
			"", -- Value
			"", -- Enum
			"", -- Keyword
			"﬌", -- Snippet
			"", -- Color
			"", -- File
			"", -- Reference
			"", -- Folder
			"", -- EnumMember
			"", -- Constant
			"", -- Struct
			"", -- Event
			"ﬦ", -- Operator
			"", -- TypeParameter
		}
	end

	local runtime_path = vim.split(package.path, ";")
	table.insert(runtime_path, "lua/?.lua")
	table.insert(runtime_path, "lua/?/init.lua")

	local server_opts = {
		["emmet_ls"] = {
			filetypes = { "html", "css", "svelte" },
		},
		["tsserver"] = {
			root_dir = lspconfig.util.root_pattern("package.json"),
		},
		["svelte"] = {
			root_dir = lspconfig.util.root_pattern("package.json"),
		},
		["eslint"] = {
			root_dir = lspconfig.util.root_pattern("package.json"),
			filetypes = {
				"javascript",
				"javascriptreact",
				"javascript.jsx",
				"typescript",
				"typescriptreact",
				"typescript.tsx",
				"vue",
				"svelte",
			},
			settings = {
				format = { enable = true },
			},
		},
		["denols"] = {
			init_options = { lint = true, unstable = true },
		},
		["sumneko_lua"] = {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
						path = runtime_path,
					},
					diagnostics = {
						globals = { "vim" },
					},
					workspace = {
						library = vim.api.nvim_get_runtime_file("", true),
					},
					telemetry = {
						enable = false,
					},
				},
			},
		},
		["pyrignt"] = {
			before_init = function(_, config)
				local p
				if vim.env.VIRTUAL_ENV then
					p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
				else
					p = utils.find_cmd("python3", ".venv/bin", config.root_dir)
				end
				config.settings.python.pythonPath = p
			end,
			settings = {
				disableOrganizeImports = true,
			},
		},
	}

	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.preselectSupport = true
	capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
	capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
	capabilities.textDocument.completion.completionItem.deprecatedSupport = true
	capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
	capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = { "documentation", "detail", "additionalTextEdits" },
	}

	lsp_installer.settings({
		ui = {
			icons = {
				server_installed = "✓",
				server_pending = "➜",
				server_uninstalled = "✗",
			},
		},
	})

	lsp_installer.on_server_ready(function(server)
		local opts = server_opts[server.name] or {}

		opts.on_attach = on_attach

		opts.capabilities = capabilities

		server:setup(opts)
	end)

	vim.fn.sign_define("DiagnosticSignError", { text = " ", texthl = "DiagnosticSignError" })
	vim.fn.sign_define("DiagnosticSignWarn", { text = " ", texthl = "DiagnosticSignWarn" })
	vim.fn.sign_define("DiagnosticSignInfo", { text = " ", texthl = "DiagnosticSignInfo" })
	vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

	local status_color, lsp_colors = pcall(require, "lsp-colors")
	if status_color then
		lsp_colors.setup()
	end
end

require("utils.plugin").force_load_on_event("lspconfig", loading)
