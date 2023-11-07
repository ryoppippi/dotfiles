return {
	"yioneko/nvim-vtsls",
	cond = not is_vscode(),
	dependencies = {
		"neovim/nvim-lspconfig",
		"kyoh86/climbdir.nvim",
		{
			"williamboman/mason-lspconfig.nvim",
			opts = function(_, opts)
				opts.ensure_installed = vim.tbl_flatten({
					opts.ensure_installed or {},
					{ "vtsls" },
				})
			end,
		},
	},
	enabled = true,
	event = function()
		local return_events = { "VeryLazy" }
		local events = { "BufReadPre", "BufNewFile" }
		local exts = { "js", "jsx", "ts", "tsx" }
		for _, ext in ipairs(exts) do
			for _, event in ipairs(events) do
				table.insert(return_events, string.format("%s *.%s", event, ext))
			end
		end
		return return_events
	end,
	opts = function()
		local commands = require("vtsls").commands
		local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
		local setup = lspconfig_opts.setup
		local lsp_opts = lspconfig_opts.lsp_opts
		local capabilities = lsp_opts.capabilities
		local inlayHints = lspconfig_opts.typescriptInlayHints

		---@class VtslsConfig
		return {
			setup = setup,
			lsp_opts = {
				on_attach = function(client, buffer)
					vim.keymap.set("n", "<leader>to", function()
						commands.add_missing_imports()
						commands.remove_unused_imports()
						-- commands.organize_imports()
					end, { desc = "Organize imports", buffer = buffer })
					vim.keymap.set("n", "gI", function()
						commands.goto_source_definition()
					end, { desc = "Go to source definition", buffer = buffer })

					lspconfig_opts.format_config(false)(client)
				end,
				root_dir = function(path)
					local marker = require("climbdir.marker")
					local found = require("climbdir").climb(
						path,
						marker.one_of(marker.has_readable_file("package.json"), marker.has_directory("node_modules")),
						{
							halt = marker.has_readable_file("deno.json"),
						}
					)
					return found
				end,
				single_file_support = false,
				capabilities = capabilities,
				settings = {
					typescript = {
						suggest = {
							completionFunctionCalls = true,
						},
						inlayHints = inlayHints,
						tsserver = {
							pluginPaths = { "." },
						},
					},
					javascript = {
						inlayHints = inlayHints,
					},
				},
			},
		}
	end,
	---@param _ any
	---@param opts VtslsConfig
	config = function(_, opts)
		local setup = opts.setup
		local lsp_opts = opts.lsp_opts

		local lspconfig = require("lspconfig")

		require("lspconfig.configs").vtsls = require("vtsls").lspconfig

		setup(lspconfig.vtsls, lsp_opts)
	end,
}
