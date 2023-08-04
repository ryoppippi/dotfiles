return {
	"rebelot/heirline.nvim",
	cond = vim.o.termguicolors and not is_vscode(),
	enabled = true,
	event = "UIEnter",
	dependencies = { "rebelot/kanagawa.nvim" },
	config = function(_, opts)
		require("heirline").setup(opts)
	end,
	opts = function()
		local conditions = require("heirline.conditions")

		return {
			-- statusline = require("plugin.heirline.statusline"),
			-- tabline = require("plugin.heirline.tabline"),
			winbar = require("plugin.heirline.winbar"),
			-- statuscolumn = require("plugin.heirline.statuscolumn"),
			opts = {
				colors = require("kanagawa.colors").setup(),
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
