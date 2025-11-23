require("core.plugin").init()
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
	-- vim.env.NVIM_COLORSCHEME = "lackluster"
	vim.env.NVIM_COLORSCHEME = "kanagawa-dragon"
end

-- load plugins
lazy.setup({
	spec = {
		{ import = "plugin" },
	},
	dev = {
		path = "~/ghq/github.com/ryoppippi/",
	},
	defaults = { lazy = true },
	install = { missing = true, colorscheme = { "kanagawa" } },
	checker = { enabled = false },
	concurrency = 64,
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"netrw",
				"tarPlugin",
				"tar",
				"tohtml",
				"tutor",
				"zipPlugin",
				"zip",
			},
		},
	},
})
