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
					{ desc = "󰊳  Update", group = "@property", action = "Lazy update", key = "u" },
					{
						desc = "Files",
						icon = "  ",
						icon_hl = "@variable",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = "File Browser",
						icon = "󰈙 ",
						icon_hl = "@variable",
						group = "Label",
						action = "Telescope find_files",
						key = "f",
					},
					{
						desc = "  MRU",
						group = "DiagnosticHint",
						action = "Telescope oldfiles",
						key = "r",
					},
				},
			},
		}
	end,
}
