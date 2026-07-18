require("core.plugin").init()
local lazy = require("lazy")

-- Nix linkFarm of plugins served read-only from the Nix store; see
-- nix/modules/home/programs/neovim/plugins.nix
local nix_plugins = vim.env.LAZY_NIX_PLUGINS

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
		---@param plugin LazyPlugin
		---@return string
		path = function(plugin)
			-- own plugins are developed from the mutable ghq checkout
			if (plugin.url or ""):find("github.com/ryoppippi/", 1, true) then
				return "~/ghq/github.com/ryoppippi/" .. plugin.name
			end
			return (nix_plugins or "") .. "/" .. plugin.name
		end,
		-- match every plugin so the Nix store copy is preferred when present;
		-- plugins without a store copy fall back to a normal git clone pinned
		-- by lazy-lock.json
		patterns = nix_plugins ~= nil and { "" } or {},
		fallback = true,
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

if nix_plugins ~= nil then
	-- lazy.nvim regenerates helptags for every local (dev) plugin on
	-- update/restore, which fails on the read-only Nix store where nixpkgs
	-- has already generated them. Patched after setup() because requiring
	-- lazy.manage.* earlier would bind lazy's internals to the bundled
	-- module cache before setup() swaps it for vim.loader.
	local task = require("lazy.manage.task.plugin")
	local docs_skip = task.docs.skip
	---@param plugin LazyPlugin
	task.docs.skip = function(plugin)
		return vim.startswith(plugin.dir or "", nix_plugins) or docs_skip(plugin)
	end
end
