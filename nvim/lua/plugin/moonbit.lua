---@type LazySpec
return {
	"moonbit-community/moonbit.nvim",
	ft = { "moonbit" },
	cond = not is_vscode(),
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	-- The default opts already enable the native language server (`moon lsp`,
	-- provided by a MoonBit toolchain installed outside Nix) and auto-install
	-- the tree-sitter grammar, which is not packaged in nixpkgs
	opts = {},
}
