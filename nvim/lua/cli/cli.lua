return {
	name = "cli",
	dir = "",
	dependencies = {
		-- ruby
		{ "Shopify/ruby-lsp", version = "*", build = { "gem install --user-install --no-document --pre ruby-lsp" } },

		-- zig
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
}
