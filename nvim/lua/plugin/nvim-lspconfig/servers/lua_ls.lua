-- based on: https://zenn.dev/uga_rosa/articles/afe384341fc2e1

local lspconfig_opts = (
	require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
)
local format_config = lspconfig_opts.format_config

local lua_ls = require("lspconfig").lua_ls

---@param names string[]
---@return string[]
local function get_plugin_paths(names)
	local plugins = require("lazy.core.config").plugins
	local paths = {}
	for _, name in ipairs(names) do
		if plugins[name] then
			table.insert(paths, plugins[name].dir .. "/lua")
		else
			vim.notify("Invalid plugin name: " .. name)
		end
	end
	return paths
end

---@param plugins string[]
---@return string[]
local function library(plugins)
	local paths = get_plugin_paths(plugins)
	table.insert(paths, vim.fn.stdpath("config") .. "/lua")
	table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
	table.insert(paths, "${3rd}/luv/library")
	table.insert(paths, "${3rd}/busted/library")
	table.insert(paths, "${3rd}/luassert/library")
	return paths
end

return {
	lua_ls,
	{
		on_attach = format_config(false),
		flags = {
			debounce_text_changes = 150,
		},
		settings = {
			Lua = {
				runtime = {
					version = "LuaJIT",
					pathStrict = true,
					path = { "?.lua", "?/init.lua" },
				},
				workspace = {
					library = library({ "lazy.nvim", "nvim-insx", "plenary.nvim", "vim-artemis" }),
					checkThirdParty = "Disable",
				},
				diagnostics = {
					globals = { "vim" },
				},
				completion = {
					showWord = "Disable",
					callSnippet = "Replace",
				},
				format = {
					enable = false,
				},
				hint = {
					enable = true,
				},
			},
		},
	},
}
