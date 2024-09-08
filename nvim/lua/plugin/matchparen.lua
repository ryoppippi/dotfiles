---@type LazySpec
return {
	"monkoose/matchparen.nvim",
	event = "VimEnter",
	init = function()
		vim.g.loaded_matchparen = 1
	end,
	opts = {},
}
