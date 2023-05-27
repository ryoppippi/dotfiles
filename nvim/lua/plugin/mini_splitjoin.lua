return {
	"echasnovski/mini.splitjoin",
	enabled = true,
	version = "*",
	event = "VeryLazy",
	opts = { mappings = { toggle = "<leader>j" } },
	config = function(_, opts)
		require("mini.splitjoin").setup(opts)
	end,
}
