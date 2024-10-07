return {
	"kawre/leetcode.nvim",
	build = ":TSUpdate html",
	cmd = "Leet",
	event = {
		"BufReadPre leetcode.nvim",
	},
	init = function()
		vim.keymap.set("ca", "lt", "Leet")
	end,
	dependencies = {
		"nvim-telescope/telescope.nvim",
		"nvim-lua/plenary.nvim", -- required by telescope
		"MunifTanjim/nui.nvim",

		-- optional
		"nvim-treesitter/nvim-treesitter",
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		-- configuration goes here
		lang = "typescript",
		storage = {
			home = "~/ghq/github.com/ryoppippi/leetcode/code/",
		},
	},
}
