local function isLackluster()
	return vim.env.NVIM_COLORSCHEME == "lackluster"
end

local COLORSCHEME_NAME = "lackluster"

---@type LazySpec
return {
	"slugbyte/lackluster.nvim",
	priority = isLackluster() and 1000 or 50,
	event = isLackluster() and { "UiEnter" } or { "VeryLazy" },
	config = function()
		local lackluster = require("lackluster")
		local color = lackluster.color -- blue, green, red, orange, black, lack, luster, gray1-9
		lackluster.setup({
			tweek_syntax = {
				comment = lackluster.color.gray4, -- or gray5
			},
			tweek_background = {
				normal = "none",
				telescope = "none",
				menu = lackluster.color.gray3,
				popup = "default",
			},
		})

		if isLackluster() then
			vim.cmd.colorscheme(COLORSCHEME_NAME)
			vim.g.colors_name = COLORSCHEME_NAME
		end
	end,
}
