local DEFUALT_THEME = "wave"
return {
	"rebelot/kanagawa.nvim",
	priority = vim.env.NVIM_COLORSCHEME == "kanagawa" and 1000 or 50,
	lazy = vim.env.NVIM_COLORSCHEME ~= "kanagawa",
	build = ":KanagawaCompile",
	cond = not is_vscode(),
	opts = function()
		return {
			overrides = function(colors)
				local theme = colors.theme
				local palette = colors.palette
				return {
					TelescopeTitle = { fg = theme.ui.special, bold = true },
					TelescopePromptNormal = { bg = theme.ui.bg_p1 },
					TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
					TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
					RainbowDelimiterRed = { fg = palette.lotusRed },
					RainbowDelimiterYellow = { fg = palette.lotusYellow },
					RainbowDelimiterBlue = { fg = palette.lotusBlue2 },
					RainbowDelimiterOrange = { fg = palette.lotusOrange },
					RainbowDelimiterGreen = { fg = palette.lotusGreen },
					RainbowDelimiterViolet = { fg = palette.lotusViolet4 },
					RainbowDelimiterCyan = { fg = palette.lotusCyan },
				}
			end,
			globalStatus = true,
			transparent = true,
			theme = DEFUALT_THEME,
		}
	end,
	config = function(_, opts)
		local k = require("kanagawa")
		k.setup(opts)
		k.load(DEFUALT_THEME)
		vim.cmd([[silent KanagawaCompile]])
	end,
}
