local lsp_utils = require("plugin.nvim-lspconfig.utils")
local ft = lsp_utils.ft
local inlayHints = lsp_utils.typescriptInlayHints

local function keymap(buffer)
	local commands = require("vtsls").commands
	vim.keymap.set("n", "<leader>to", function()
		commands.add_missing_imports()
		commands.remove_unused_imports()
		-- commands.organize_imports()
	end, { desc = "Organize imports", buffer = buffer })
	vim.keymap.set("n", "gI", function()
		commands.goto_source_definition()
	end, { desc = "Go to source definition", buffer = buffer })
end

-- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
return {
	on_attach = function(_, buffer)
		keymap(buffer)
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
					{
						name = "@astrojs/ts-plugin",
					},
					-- {
					--   name = "@vue/typescript-plugin",
					--   languages = { "vue" },
					-- },
				},
			},
		},
		javascript = {
			inlayHints = inlayHints,
		},
	},
}
