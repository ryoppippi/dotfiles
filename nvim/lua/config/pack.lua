require("core.plugin").init()
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
	vim.env.NVIM_COLORSCHEME = "kanagawa"
end

-- load plugins
lazy.setup("plugin", {
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

vim.api.nvim_create_user_command("LazyNewPlugin", function()
	local Path = require("plenary.path")
	vim.cmd("echo 'input plugin name'")
	local plugin_name = vim.fn.input("plugin name: ")
	if plugin_name == "" then
		return
	end
	local plugin_path = Path:new(vim.fn.stdpath("config"), "lua", "plugin", plugin_name .. ".lua"):absolute()
	-- check if exists
	if not tb(vim.fn.filereadable(plugin_path)) then
		local plugin_file = io.open(plugin_path, "w")
		if plugin_file == nil then
			return
		end
		plugin_file:write("return {\n\n}\n")
		plugin_file:close()
	end

	vim.cmd.edit(plugin_path)
end, {
	desc = "create new plugin",
	nargs = 0,
})
