return {
	"goolord/alpha-nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local alpha = require("alpha")
		local startify = require("alpha.themes.startify")
		startify.section.header.val = {
			[[                                   __                ]],
			[[      ___     ___    ___   __  __ /\_\    ___ ___    ]],
			[[     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
			[[    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
			[[    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
			[[     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
		}
		startify.section.top_buttons.val = {
			startify.button("e", "  New file", "<cmd>enew<cr>"),
			startify.button("s", "  Restore Session", '<cmd>lua require("persistence").load()<cr>'),
			startify.button("f", "  Files", "<cmd>Telescope find_files<cr>"),
			startify.button(".", "󰈙  Oil", "<cmd>Oil<cr>"),
			startify.button("r", "  MRU", "<cmd>Telescope oldfiles<cr>"),
			startify.button("d", "  dotfiles", "<cmd>Config<cr>"),
			startify.button("z", "󰒲  Lazy", "<cmd>Lazy<cr>"),
		}
		alpha.setup(startify.config)
	end,
}
