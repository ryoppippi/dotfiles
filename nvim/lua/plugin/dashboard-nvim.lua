return {
	"glepnir/dashboard-nvim",
	dependencies = { { "nvim-tree/nvim-web-devicons" } },
	event = "VimEnter",
	opts = function()
		return {
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				shortcut = {
					{
						desc = "Restore Session",
						icon = " ",
						icon_hl = "@function",
						action = 'lua require("persistence").load()',
						key = "s",
					},
					{
						desc = "Files",
						icon = " ",
						icon_hl = "@variable",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = "Oil",
						icon = "󰈙 ",
						icon_hl = "@variable",
						group = "Label",
						action = ":Oil",
						key = ".",
					},
					{
						desc = "MRU",
						icon = " ",
						group = "DiagnosticHint",
						action = "Telescope oldfiles",
						key = "r",
					},
					{
						desc = "dotfiles",
						icon = " ",
						action = "Config",
						key = "d",
					},
					{
						desc = "Lazy",
						icon = "󰒲 ",
						icon_hl = "@property",
						group = "Label",
						action = "Lazy",
						key = "z",
					},
					-- {
					-- 	desc = "Quit",
					-- 	icon = " ",
					-- 	icon_hl = "@property",
					-- 	action = "qa",
					-- 	key = "q",
					-- },
				},
			},
		}
	end,
}
