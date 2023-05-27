return {
	"altermo/ultimate-autopair.nvim",
	lazy = false,
	dependencies = {
		{ "altermo/npairs-integrate-upair", opts = { map = "u" } },
		"windwp/nvim-autopairs",
	},
	event = { "InsertEnter", "CmdlineEnter" },
	-- opts = {},
}
