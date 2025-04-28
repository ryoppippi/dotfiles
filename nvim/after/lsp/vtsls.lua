local lsp_utils = require("plugin.nvim-lspconfig.utils")
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
	workspace_required = true,
	settings = {
		typescript = {
			format = {
				enable = false,
			},
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
			format = {
				enable = false,
			},
			inlayHints = inlayHints,
		},
	},
}
