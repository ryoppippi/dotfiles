-- based on: https://zenn.dev/uga_rosa/articles/afe384341fc2e1

local lsp_utils = require("plugin.nvim-lspconfig.utils")
local setup = lsp_utils.setup
local format_config = lsp_utils.format_config

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

---@type LazySpec
return {
	name = "lua_ls",
	dir = vim.env.TMPDIR .. "/lsp-lua_ls",
	dependencies = { "neovim/nvim-lspconfig" },
	ft = function(spec)
		return lsp_utils.get_default_filetypes(spec.name)
	end,
	opts = function()
		return {
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
						library = library({
							"lazy.nvim",
							"nvim-insx",
							"plenary.nvim",
							"vim-artemis",
							"oil.nvim",
							"nui.nvim",
							"noice.nvim",
							"nvim-cmp",
							"nvim-lspconfig",
						}),
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
		}
	end,
	config = function(spec, opts)
		setup(spec.name, opts)
	end,
}
