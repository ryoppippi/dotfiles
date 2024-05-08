local utils = require("core.utils")
local lsp_utils = require("core.lsp.utils")
local has_cmp = lsp_utils.has_cmp

return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile", "VeryLazy" },
	cond = not is_vscode(),
	dependencies = {
		"node_servers",
		"cli",
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
	config = function()
		local format_config = lsp_utils.format_config
		local setup = lsp_utils.setup
		local html_like = lsp_utils.html_like
		local typescriptInlayHints = lsp_utils.typescriptInlayHints

		local lspconfig = require("lspconfig")

		-- server configs

		-- efm
		setup(lspconfig.efm, {
			filetypes = vim.tbl_flatten({
				{
					"lua",
					"python",
					"go",
					"rust",
					"swift",
				},
				-- config
				{
					"json",
					"jsonc",
					"json5",
					"yaml",
				},
				-- others
				{

					"fish",
					"dockerfile",
				},
				-- web
				{
					-- -- markup
					"html",
					"svelte",
					"vue",
					"astro",
					"javascriptreact",
					"javascript.jsx",
					"typescriptreact",
					"typescript.tsx",
					"markdown",
					"markdown.mdx",
					-- -- style
					"css",
					"scss",
					"less",

					-- -- script
					"javascript",
					"typescript",
				},
			}),
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
		setup(lspconfig.stylelint_lsp, { on_attach = format_config(false) })

		setup(lspconfig.eslint, {
			extra_filetypes = { "svelte" },
			on_attach = format_config(false),
		})

		setup(lspconfig.biome)

		setup(lspconfig.denols, {
			single_file_support = false,
			root_dir = function(path)
				local marker = require("climbdir.marker")
				local found = require("climbdir").climb(
					path,
					marker.one_of(
						marker.has_readable_file("deno.json"),
						marker.has_readable_file("deno.jsonc"),
						marker.has_directory("denops")
					),
					{
						halt = marker.one_of(
							marker.has_readable_file("package.json"),
							marker.has_directory("node_modules")
						),
					}
				)
				if found then
					vim.b[vim.fn.bufnr()].deno_deps_candidate = vim.fs.joinpath(found, "deps.ts")
				end
				return found
			end,
			on_attach = function(_, buffer)
				vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost" }, {
					buffer = buffer,
					callback = function()
						vim.cmd.DenolsCache()
					end,
				})
			end,
			settings = {
				deno = {
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
			},
		})

		-- web DSL
		setup(lspconfig.svelte, {
			on_attach = function(client, _)
				vim.api.nvim_create_autocmd("BufWritePost", {
					pattern = { "*.js", "*.ts" },
					callback = function(ctx)
						client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
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
		setup(unpack(require("plugin.nvim-lspconfig.servers.lua_ls")))

		-- json
		setup(lspconfig.jsonls, {
			on_attach = format_config(false),
			filetypes = { "json", "jsonc", "json5" },
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
					validate = { enable = true },
					format = { enable = true },
				},
			},
		})

		setup(unpack(require("plugin.nvim-lspconfig.servers.lua_ls")))

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

		-- toml
		setup(lspconfig.taplo)

		-- swift
		setup(lspconfig.sourcekit)

		-- ruby
		setup(lspconfig.ruby_lsp)

		-- python
		local python_lsp_init = function(_, config)
			config.settings.python.pythonPath = vim.env.VIRTUAL_ENV
					and lspconfig.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
				or utils.find_cmd("python3", ".venv/bin", config.root_dir)
		end
		setup(lspconfig.pyright, { before_init = python_lsp_init })
		setup(lspconfig.ruff_lsp, { before_init = python_lsp_init })

		-- r
		setup(lspconfig.r_language_server)

		-- sql
		setup(lspconfig.sqls)

		-- zls
		setup(lspconfig.zls)
		vim.g.zig_fmt_autosave = 0
	end,
}
