-- Dump lazy.nvim's resolved plugin table as JSON for lazy2nix.
-- Run inside the user's Neovim after startup so the full spec tree
-- (including dependencies) has been resolved:
--   nvim --headless "+lua dofile('.../dump.lua')" +qa
-- The output path is taken from $LAZY2NIX_DUMP.
local out_path = assert(vim.env.LAZY2NIX_DUMP, "LAZY2NIX_DUMP is not set")

local plugins = require("lazy.core.config").plugins
local out = {}
for name, plugin in pairs(plugins) do
	out[#out + 1] = {
		name = name,
		url = plugin.url,
		virtual = plugin.virtual or false,
		-- spec pins; ignored by lazy.nvim for dev plugins, so lazy2nix
		-- warns when a pinned plugin is about to be Nix-served
		version = plugin.version,
		branch = plugin.branch,
		commit = plugin.commit,
		has_build = plugin.build ~= nil,
	}
end
table.sort(out, function(a, b)
	return a.name < b.name
end)

local f = assert(io.open(out_path, "w"))
f:write(vim.json.encode(out))
f:close()
