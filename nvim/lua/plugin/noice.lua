return {
	"folke/noice.nvim",
	event = "VeryLazy",
	enabled = true,
	cond = not is_vscode(),
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	opts = {
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
			backend = "cmp",
		},
		notify = {
			enabled = true,
			view = "mini",
		},
		cmdline = {
			enabled = true,
		},
		messages = {
			view_search = false,
			view = "mini",
		},
		presets = {
			inc_rename = true,
			lsp_doc_border = true,
		},
	},
	config = true,
}
