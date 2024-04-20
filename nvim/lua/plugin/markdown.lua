---@type LazySpec
return {
	"MeanderingProgrammer/markdown.nvim",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	ft = { "markdown" },
	opts = {
		headings = {
			"󰉫 ", -- nf-md-format_header_1
			"󰉬 ", -- nf-md-format_header_2
			"󰉭 ", -- nf-md-format_header_3
			"󰉮 ", -- nf-md-format_header_4
			"󰉯 ", -- nf-md-format_header_5
			"󰉰 ", -- nf-md-format_header_6
		},
		dash = "", -- nf-oct-dash
		bullets = {
			" ", -- nf-oct-dot_fill
			" ", -- nf-oct-dot
		},
		checkbox = {
			unchecked = "󰄱 ", -- nf-md-checkbox_blank_outline
			checked = "󰱒 ", -- nf-md-checkbox_outline
		},
		quote = "┃",
	},
}
