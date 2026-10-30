return {
	"saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	requires = {
		"nvim-lua/plenary.nvim",
	},
	opts = {
		lsp = { enabled = false },
	},
}
