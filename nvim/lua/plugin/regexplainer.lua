return {
	"bennypowers/nvim-regexplainer",
	keys = { "gR" },
	config = function()
		require("regexplainer").setup({
			display = "popup",
			mappings = {
				toggle = "gR",
				-- examples, not defaults:
				-- show = 'gS',
				-- hide = 'gH',
				-- show_split = 'gP',
				-- show_popup = 'gU',
			},
		})
	end,
}
