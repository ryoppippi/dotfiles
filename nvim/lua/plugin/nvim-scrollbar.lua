return {
	"petertriho/nvim-scrollbar",
	event = "VeryLazy",
	enabled = false,
	opts = {
		show = true,
		set_highlights = false,
	},
	config = function(_, opts)
		require("scrollbar").setup(opts)
		if require("core.plugin").has("nvim-hlslens") then
			require("scrollbar.handlers.search").setup(opts)
		end
		if require("core.plugin").has("gitsigns.nvim") then
			require("scrollbar.handlers.gitsigns").setup()
		end
	end,
}
