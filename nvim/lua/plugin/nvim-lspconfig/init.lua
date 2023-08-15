local utils = require("core.utils")

---@return boolean 'is cmp installed?'
local function has_cmp()
	return require("core.plugin").has("nvim-cmp")
end

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	cond = not is_vscode(),
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"folke/neoconf.nvim",
		"b0o/schemastore.nvim",
		{ "hrsh7th/cmp-nvim-lsp", cond = has_cmp },
		{ "hrsh7th/cmp-nvim-lsp-document-symbol", cond = has_cmp },
		{ "hrsh7th/cmp-nvim-lsp-signature-help", cond = has_cmp, enabled = false },
	},
	init = function()
		require("core.plugin").on_attach(function(client, bufnr)
			local exclude_ft = { "oil" }
			local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
			if vim.tbl_contains(exclude_ft, ft) then
				return
			end

			require("plugin.nvim-lspconfig.keymaps").on_attach(client, bufnr)
			require("plugin.nvim-lspconfig.diagnostic").on_attach(client, bufnr)
			require("plugin.nvim-lspconfig.format").on_attach(client, bufnr)
			require("plugin.nvim-lspconfig.inlayhints").on_attach(client, bufnr)

			vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		end)
	end,
	opts = function()
		---@class LSPConfigOpts
		local o = { lsp_opts = {} }

		o.lsp_opts.capabilities = vim.tbl_deep_extend(
			"force",
			{},
			vim.lsp.protocol.make_client_capabilities(),
			has_cmp() and require("cmp_nvim_lsp").default_capabilities() or {}
		)
		o.lsp_opts.capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = true

		o.node_root_dir = {
			"package.json",
			"tsconfig.json",
			"tsconfig.jsonc",
			"node_modules",
		}

		o.html_like = {
			"astro",
			"html",
			"htmldjango",
			"css",
			"javascriptreact",
			"javascript.jsx",
			"typescriptreact",
			"typescript.tsx",
			"svelte",
			"vue",
			"markdown",
		}

		o.typescriptInlayHints = {
			parameterNames = {
				enabled = "literals", -- 'none' | 'literals' | 'all'
				suppressWhenArgumentMatchesName = true,
			},
			parameterTypes = { enabled = false },
			variableTypes = { enabled = false },
			propertyDeclarationTypes = { enabled = true },
			functionLikeReturnTypes = { enabled = false },
			enumMemberValues = { enabled = true },
		}

		function o.format_config(enabled)
			return function(client)
				client.server_capabilities.documentFormattingProvider = enabled
				client.server_capabilities.documentRangeFormattingProvider = enabled
			end
		end

		function o.setup(client, extra_opts)
			-- vim.print(client.document_config)
			local default_opts = client.document_config.default_config

			local local_opts = vim.tbl_deep_extend("force", {}, o.lsp_opts, extra_opts or {})

			local_opts.filetypes = vim.tbl_flatten({
				local_opts.filetypes or default_opts.filetypes or {},
				local_opts.extra_filetypes or {},
			})
			local_opts.extra_filetypes = nil
			client.setup(local_opts)
		end

		return o
	end,
	---@param _ any
	---@param opts LSPConfigOpts
	config = function(_, opts)
		local format_config = opts.format_config
		local setup = opts.setup
		local html_like = opts.html_like
		local node_root_dir = opts.node_root_dir
		local typescriptInlayHints = opts.typescriptInlayHints

		local lspconfig = require("lspconfig")

		-- server configs

		-- efm
		setup(lspconfig.efm, {
			filetypes = {
				"fish",
				"lua",
				"dockerfile",
			},
			init_options = {
				documentFormatting = true,
				rangeFormatting = true,
				hover = true,
				documentSymbol = true,
				codeAction = true,
				completion = true,
			},
		})

		-- html/css/js
		setup(lspconfig.emmet_ls, { extra_filetypes = html_like, on_attach = format_config(false) })
		setup(lspconfig.tailwindcss, { extra_filetypes = html_like, on_attach = format_config(false) })
		setup(lspconfig.html, { on_attach = format_config(false) })

		setup(lspconfig.eslint, {
			extra_filetypes = { "svelte" },
			root_dir = lspconfig.util.root_pattern(node_root_dir),
			on_attach = format_config(false),
		})

		setup(lspconfig.denols, {
			single_file_support = false,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc", "import_map.json"),
			init_options = {
				lint = true,
				unstable = true,
				suggest = {
					imports = {
						hosts = {
							["https://deno.land"] = true,
							["https://cdn.nest.land"] = true,
							["https://crux.land"] = true,
							["https://esm.sh"] = true,
						},
					},
				},
			},
		})

		-- web DSL
		setup(lspconfig.svelte, {
			on_attach = function(client, _)
				local root_dir = client.config.root_dir
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = {
						root_dir .. "/*.js",
						root_dir .. "/*.ts",
					},
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
					end,
				})
				format_config(false)(client)
			end,
			settings = {
				typescript = {
					inlayHints = typescriptInlayHints,
				},
			},
		})
		setup(lspconfig.astro, { on_attach = format_config(false) })
		setup(lspconfig.angularls)
		setup(lspconfig.vuels)
		setup(lspconfig.prismals)

		-- lua
		setup(lspconfig.lua_ls, {
			on_attach = format_config(false),
			flags = {
				debounce_text_changes = 150,
			},
			settings = {
				Lua = {
					diagnostics = {
						globals = { "vim" },
					},
					completion = {
						showWord = "Disable",
						callSnippet = "Replace",
					},
					workspace = {
						checkThirdParty = false,
					},
					hint = {
						enable = true,
					},
				},
			},
		})

		-- json
		setup(lspconfig.jsonls, {
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
					format = { enable = true },
				},
			},
		})

		-- yaml
		setup(lspconfig.yamlls, {
			settings = {
				yaml = {
					schemas = require("schemastore").yaml.schemas({
						extra = {
							{
								name = "openAPI 3.0",
								url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml",
							},
							{

								name = "openAPI 3.1",
								url = "https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.yaml",
							},
						},
					}),
					validate = true,
					format = { enable = true },
				},
			},
		})

		-- swift
		setup(lspconfig.sourcekit)

		-- python
		setup(lspconfig.pyright, {
			before_init = function(_, config)
				config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
						and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
					or utils.find_cmd("python3", ".venv/bin", config.root_dir)
			end,
		})

		-- zigls
		local zls_path = os.getenv("HOME") .. "/zls/zig-out/bin/zls"
		local zls = lspconfig.zls
		setup(zls, {
			cmd = tb(vim.fn.executable(zls_path)) and { zls_path } or zls.document_config.default_config.cmd,
		})
		vim.g.zig_fmt_autosave = 0
	end,
}
