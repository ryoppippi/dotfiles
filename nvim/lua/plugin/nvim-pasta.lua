return {
	"hrsh7th/nvim-pasta",
	keys = {
		{
			"p",
			function()
				require("pasta.mappings").p()
			end,
			mode = { "n", "x" },
		},
		{
			"P",
			function()
				require("pasta.mappings").P()
			end,
			mode = { "n", "x" },
		},
		{
			"<C-p>",
			function()
				require("pasta.mappings").toggle_pin()
			end,
			mode = { "n" },
		},
	},
	opts = function()
		return {
			converters = {
				require("pasta.converters").indentation,
			},
			paste_mode = true,
			prevent_diagnostics = false,
			next_key = vim.api.nvim_replace_termcodes("<C-p>", true, true, true),
			prev_key = vim.api.nvim_replace_termcodes("<C-n>", true, true, true),
		}
	end,
	config = function(_, opts)
		require("pasta").setup(opts)
		require("pasta").setup.filetype({ "markdown", "yaml" }, {
			converters = {},
		})
	end,
}
