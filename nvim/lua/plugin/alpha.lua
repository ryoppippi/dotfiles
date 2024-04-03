return {
	"goolord/alpha-nvim",
	lazy = false,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	opts = function()
		local theta = require("alpha.themes.theta")
		local dashboard = require("alpha.themes.dashboard")
		theta.header.val = {
			[[                                   __                ]],
			[[      ___     ___    ___   __  __ /\_\    ___ ___    ]],
			[[     / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  ]],
			[[    /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ ]],
			[[    \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
			[[     \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
		}
		theta.buttons.val = {
			dashboard.button("e", "  New file", "<cmd>enew<cr>"),
			dashboard.button("s", "  Restore Session", '<cmd>lua require("persistence").load()<cr>'),
			dashboard.button("f", "  Files", "<cmd>Telescope find_files<cr>"),
			dashboard.button(".", "󰈙  Oil", "<cmd>Oil<cr>"),
			dashboard.button("r", "  MRU", "<cmd>Telescope oldfiles<cr>"),
			dashboard.button("d", "  dotfiles", "<cmd>Config<cr>"),
			dashboard.button("z", "󰒲  Lazy", "<cmd>Lazy<cr>"),
		}
		return theta.config
	end,
	config = function(_, opts)
		require("alpha").setup(opts)
	end,
}
