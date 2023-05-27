return {
	"navarasu/onedark.nvim",
	priority = vim.env.NVIM_COLORSCHEME == "onedark" and 1000 or 50,
	lazy = vim.env.NVIM_COLORSCHEME ~= "onedark",
	config = function()
		vim.g.onedark_config = {
			style = "cool",
			transparent = true,
			term_colors = true,
			ending_tildes = true,
			toggle_style_key = "<leader>ws",
			code_style = {
				comments = "italic",
				keywords = "italic",
				functions = "bold",
				strings = "none",
				variables = "none",
			},
			highlights = {
				rainbowcol1 = { fg = "#7645c4" },
				TSPunctBracket = { fg = "#7645c4" },
			},
			diagnostics = {
				darker = true, -- darker colors for diagnostic
				undercurl = true, -- use undercurl instead of underline for diagnostics
				background = true, -- use background color for virtual text
			},
		}
		vim.api.nvim_create_autocmd("ColorScheme", {
			pattern = "onedark",
			command = [[hi MatchParen ctermbg=black guibg=black]],
		})
	end,
}
