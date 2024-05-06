---@type LazySpec
return {
	dir = "",
	name = "ryoppippi-snippets-list",
	dependencies = {
		"craigmac/vim-vsnip-snippets",
		"honza/vim-snippets",
		"rafamadriz/friendly-snippets",

		-- language specific snippets
		-- python
		"cstrap/flask-snippets",
		"cstrap/python-snippets",
		-- zig
		"Metalymph/zig-snippets",
		-- web
		"fivethree-team/vscode-svelte-snippets",
		"xabikos/vscode-javascript",
		{
			name = "ryoppippi_my_vscode_snippets",
			dir = vim.fs.joinpath(vim.fn.stdpath("config"), "my_vscode_snippets"),
		},
	},
}

