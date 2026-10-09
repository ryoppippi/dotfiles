require("core.plugin").init()
-- nvimx wraps lazy.setup to serve every plugin read-only from the Nix store;
-- see nix/modules/home/programs/neovim/
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
	vim.env.NVIM_COLORSCHEME = "kanagawa-dragon"
end

-- load plugins
lazy.setup({
	spec = {
		{ import = "plugin" },
	},
	defaults = { lazy = true },
	install = { colorscheme = { "kanagawa" } },
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
