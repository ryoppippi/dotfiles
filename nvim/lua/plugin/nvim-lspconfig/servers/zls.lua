return {
	name = "@lsp/zls",
	dir = "",
	ft = { "zig", "zir", "zon" },
	dependencies = {
		"neovim/nvim-lspconfig",
		{
			"zigtools/zls",
			build = {
				"bun x @oven/zig build -Doptimize=ReleaseSafe --verbose",
			},
			config = function(spec)
				local dir = spec.dir

				local BIN_DIR = dir .. "/zig-out/bin"

				if not tb(vim.fn.isdirectory(BIN_DIR)) then
					vim.fn.mkdir(BIN_DIR, "p")
				end

				vim.env.PATH = BIN_DIR .. ":" .. vim.env.PATH
			end,
		},
	},
	config = function()
		local lspconfig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts() --[[@as LSPConfigOpts]]
		local setup = lspconfig_opts.setup

		setup("zls", {})
		vim.g.zig_fmt_autosave = 0
	end,
}
