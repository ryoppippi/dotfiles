return {
	"yioneko/nvim-vtsls",
	cond = not is_vscode(),
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	enabled = true,
	event = function()
		local return_events = {}
		local events = { "BufReadPre", "BufNewFile" }
		local exts = { "js", "jsx", "ts", "tsx" }
		for _, ext in ipairs(exts) do
			for _, event in ipairs(events) do
				table.insert(return_events, string.format("%s *.%s", event, ext))
			end
		end
		return return_events
	end,
	config = function()
		local commands = require("vtsls").commands
		local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()
		local inlayHints = lspconfig_opts.typescriptInlayHints

		require("lspconfig.configs").vtsls = require("vtsls").lspconfig
		require("lspconfig.configs")
		require("lspconfig").vtsls.setup({
			on_attach = function(client, buffer)
				vim.keymap.set("n", "<leader>to", function()
					commands.add_missing_imports()
					commands.remove_unused_imports()
					-- commands.organize_imports()
				end, { desc = "Organize imports", buffer = buffer })

				lspconfig_opts.disable_formatting(client, buffer)
			end,
			capabilities = lspconfig_opts.capabilities,
			single_file_support = false,
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
		})
	end,
}
