return {
	"kylechui/nvim-surround",
	version = "*", -- Use for stability; omit to use `main` branch for the latest features
	enabled = false,
	event = "VeryLazy",
	opts = {
		move_cursor = false,
		keymaps = {
			-- vim-surround style keymaps
			insert = "<C-s>",
			insert_line = "<C-s><C-s>",
			normal = "sa",
			normal_line = "saa",
			normal_cur_line = "sS",
			visual = "s",
			delete = "sd",
			change = "sr",
		},
		aliases = {
			["a"] = "a",
			["b"] = { ")", "]", "}", ">" }, -- Any brackets
			["B"] = "B",
			["r"] = "r",
			["q"] = { '"', "'", "`" }, -- Any quote character
			["s"] = "s",
			[";"] = { ")", "]", "}", ">", "'", '"', "`" }, -- Any surrounding delimiter
		},
		highlight = { -- Highlight before inserting/changing surrounds
			duration = 0,
		},
	},
}
