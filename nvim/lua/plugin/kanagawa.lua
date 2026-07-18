local TRANSPARENT = true

local isKanagawa = function()
	return vim.startswith(vim.env.NVIM_COLORSCHEME, "kanagawa")
end

return {
	"rebelot/kanagawa.nvim",
	priority = isKanagawa() and 1000 or 50,
	event = isKanagawa() and { "UiEnter" } or { "ColorScheme" },
	build = ":KanagawaCompile",
	cond = not is_vscode(),
	init = function()
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function(args)
				if not vim.startswith(args.match, "kanagawa") then
					return
				end
				vim.g.colors_name = args.match
			end,
		})
	end,
	opts = function()
		return {
			overrides = function(colors)
				local theme = colors.theme
				return {
					-- StatusLine {{
					StatusLine = { link = "Normal" },
					StatusLineNC = { link = "Normal" },
					-- }}

					-- SatelliteBar {{
					SatelliteBar = { bg = theme.ui.special },
					-- }}

					-- Copilot {{
					CopilotAnnotation = { bg = theme.ui.bg_p1, italic = true },
					CopilotSuggestion = { bg = theme.ui.bg_p2, italic = true },
					-- }}
					-- Noice {{
					NoiceVirtualText = { bg = theme.ui.bg_search },
					-- }}
				}
			end,
			globalStatus = true,
			transparent = TRANSPARENT,
			compile = true,
		}
	end,
	config = function(_, opts)
		local k = require("kanagawa")
		k.setup(opts)
		if isKanagawa() then
			vim.cmd.colorscheme(vim.env.NVIM_COLORSCHEME)
		end
	end,
}
