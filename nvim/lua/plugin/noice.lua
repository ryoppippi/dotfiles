local has = require("core.plugin").has
return {
	"folke/noice.nvim",
	event = "VeryLazy",
	enabled = true,
	cond = not is_vscode(),
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	init = function()
		require("plugin.telescope").le("noice")
	end,
	opts = function()
		return
		---@type NoiceConfig
		{
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			popupmenu = {
				enabled = true,
				backend = has("nvim-cmp") and "cmp" or "nui",
			},
			notify = {
				enabled = true,
				view = "mini",
			},
			cmdline = {
				enabled = true,
			},
			messages = {
				view_search = "virtualtext",
				view = "mini",
			},
			presets = {
				inc_rename = true,
				lsp_doc_border = true,
				long_message_to_split = true,
			},
		}
	end,
	config = true,
}
