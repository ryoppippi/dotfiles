-- based on: https://zenn.dev/uga_rosa/articles/afe384341fc2e1

local lspconfig_opts = (
	require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
)
local format_config = lspconfig_opts.format_config

local lua_ls = require("lspconfig").lua_ls
local i = require("plenary.iterators")

---@param names string[]
---@return Iterator<string>
local function get_plugin_paths(names)
	local plugins = require("lazy.core.config").plugins
	return i.iter(names)
		:filter(function(n)
			local ia = plugins[n] ~= nil
			if not ia then
				vim.notify("Invalid plugin name: " .. n)
			end
			return ia
		end)
		:map(function(n)
			return plugins[n].dir .. "/lua"
		end)
end

---@param plugins string[]
---@return string[]
local function library(plugins)
	local paths = get_plugin_paths(plugins)

	return i.iter({
		vim.fn.stdpath("config") .. "/lua",
		vim.env.VIMRUNTIME .. "/lua",
		"${3rd}/luv/library",
		"${3rd}/busted/library",
		"${3rd}/luassert/library",
	})
		:chain(paths)
		:tolist()
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
