return {
	"rebelot/heirline.nvim",
	cond = vim.o.termguicolors and not is_vscode(),
	enabled = true,
	event = "BufReadPost",
	dependencies = { "rebelot/kanagawa.nvim" },
	config = function(_, opts)
		require("heirline").setup(opts)
	end,
	opts = function()
		local conditions = require("heirline.conditions")
		-- local colors = require("kanagawa.colors").setup()
		local _, kanagawa_colors = pcall(require, "kanagawa.colors")
		local _, colors = pcall(kanagawa_colors.setup)

		return {
			-- statusline = require("plugin.heirline.statusline"),
			-- tabline = require("plugin.heirline.tabline"),
			winbar = require("plugin.heirline.winbar"),
			-- statuscolumn = require("plugin.heirline.statuscolumn"),
			opts = {
				colors,
				disable_winbar_cb = function(args)
					return conditions.buffer_matches({
						buftype = {
							"nofile",
							"prompt",
							"help",
							"quickfix",
							"terminal",
						},
						filetype = {
							"toggleterm",
							"Trouble",
							"noice",
							"alpha",
							"lir",
						},
					}, args.buf)
				end,
			},
		}
	end,
}
