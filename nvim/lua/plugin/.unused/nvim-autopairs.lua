local has = require("core.plugin").has

return {

	{
		"windwp/nvim-autopairs",
		event = { "InsertEnter" },
		enabled = false,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = {
			check_ts = true,
			enable_check_bracket_line = true,
			ignored_next_char = "[%w%.]",
		},
	},
	{
		dir = "",
		name = "after_auto_pairs",
		dependencies = {
			"hrsh7th/nvim-cmp",
			"windwp/nvim-autopairs",
		},
		cond = function()
			return has("nvim-autopairs")
		end,
		event = { "User CmpLoaded" },
		config = function()
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
		end,
	},
}
