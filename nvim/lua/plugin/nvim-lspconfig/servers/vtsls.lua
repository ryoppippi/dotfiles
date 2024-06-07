local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft

local filetypes = ft.js_like

---@type LazySpec
return {
	"yioneko/nvim-vtsls",
	cond = not is_vscode(),
	dependencies = {
		"node_servers",
		"neovim/nvim-lspconfig",
	},
	enabled = true,
	ft = filetypes,
	opts = function()
		local commands = require("vtsls").commands
		local format_config = lsp_utils.format_config
		local lsp_default_opts = lsp_utils.default_opts()
		local capabilities = lsp_default_opts.capabilities
		local inlayHints = lsp_utils.typescriptInlayHints

		---setup keymap
		local function keymap(client, buffer)
			vim.keymap.set("n", "<leader>to", function()
				commands.add_missing_imports()
				commands.remove_unused_imports()
				-- commands.organize_imports()
			end, { desc = "Organize imports", buffer = buffer })
			vim.keymap.set("n", "gI", function()
				commands.goto_source_definition()
			end, { desc = "Go to source definition", buffer = buffer })
		end

		---@class VtslsConfig
		return {
			filetypes = filetypes,
			on_attach = function(client, buffer)
				keymap(client, buffer)
				format_config(false)(client)
			end,
			single_file_support = false,
			root_dir = function(path)
				---@param current_path string|nil
				local function find_root(current_path)
					if current_path == nil or current_path == "" then
						return nil
					end

					local project_root =
						vim.fs.root(current_path, vim.iter({ ".git", ft.node_files }):flatten(math.huge):totable())

					if project_root == nil then
						return nil
					end

					local is_node_files_found = vim.iter(ft.node_specific_files):any(function(file)
						return vim.uv.fs_stat(vim.fs.joinpath(project_root, file)) ~= nil
					end)

					if is_node_files_found then
						return project_root
					end

					if vim.uv.fs_stat(vim.fs.joinpath(project_root, ".git")) ~= nil then
						return nil
					end

					return find_root(vim.fs.dirname(current_path))
				end

				return find_root(path)
			end,
			capabilities = capabilities,
			settings = {
				typescript = {
					suggest = {
						completionFunctionCalls = true,
					},
					inlayHints = inlayHints,
					tsserver = {
						pluginPaths = { "." },
						globalPlugins = {
							{
								name = "typescript-svelte-plugin",
								enableForWorkspaceTypeScriptVersions = true,
							},
						},
					},
				},
				javascript = {
					inlayHints = inlayHints,
				},
			},
		}
	end,

	---@param _ any
	---@param opts VtslsConfig
	config = function(_, opts)
		local setup = lsp_utils.setup
		require("lspconfig.configs").vtsls = require("vtsls").lspconfig
		setup("vtsls", opts)
	end,
}
