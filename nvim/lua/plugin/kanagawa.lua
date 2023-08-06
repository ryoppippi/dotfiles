local DEFUALT_THEME = "dragon"
return {
	"rebelot/kanagawa.nvim",
	priority = vim.env.NVIM_COLORSCHEME == "kanagawa" and 1000 or 50,
	-- lazy = vim.env.NVIM_COLORSCHEME ~= "kanagawa",
	event = function()
		if vim.env.NVIM_COLORSCHEME == "kanagawa" then
			return { "UiEnter" }
		else
			return { "VeryLazy" }
		end
	end,
	build = ":KanagawaCompile",
	cond = not is_vscode(),
	opts = function()
		return {
			overrides = function(colors)
				local theme = colors.theme
				return {
					TelescopeTitle = { fg = theme.ui.special, bold = true },
					TelescopePromptNormal = { bg = theme.ui.bg_p1 },
					TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
					TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
					TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
					TelescopePreviewNormal = { bg = theme.ui.bg_dim },
					TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },
					RainbowDelimiterRed = { fg = theme.syn.preproc },
					RainbowDelimiterYellow = { fg = theme.syn.special2 },
					RainbowDelimiterBlue = { fg = theme.syn.fun },
					RainbowDelimiterOrange = { fg = theme.syn.number },
					RainbowDelimiterGreen = { fg = theme.syn.string },
					RainbowDelimiterViolet = { fg = theme.syn.statement },
					RainbowDelimiterCyan = { fg = theme.syn.type },
					CopilotAnnotation = { bg = theme.ui.bg_p1 },
					CopilotSuggestion = { bg = theme.ui.bg_p2 },
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
