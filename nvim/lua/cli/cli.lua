return {
	name = "cli",
	dir = "",
	dependencies = {
		"nvim-lua/plenary.nvim",
		-- ruby
		{ "Shopify/ruby-lsp", version = "*", build = { "gem install --user-install --no-document --pre ruby-lsp" } },

		-- zig
		{
			"zigtools/zls",
			build = {
				"zig build -Doptimize=ReleaseSafe --verbose",
			},
			config = function(spec)
				local Path = require("plenary.path")

				local dir = spec.dir

				local BIN_DIR = Path:new(dir, "zig-out", "bin")

				if not (BIN_DIR:exists()) then
					BIN_DIR:mkdir({ parents = true })
				end

				vim.env.PATH = BIN_DIR:absolute() .. ":" .. vim.env.PATH
			end,
		},

		-- rust
		{
			name = "rust-analyzer",
			dir = "",
			build = { "rustup component add rust-analyzer" },
		},
	},
}
