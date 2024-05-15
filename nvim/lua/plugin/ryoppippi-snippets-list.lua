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
		-- web
		"fivethree-team/vscode-svelte-snippets",
		"xabikos/vscode-javascript",

		-- personla snippets
		{ "ryoppippi/my-personal-snippets", dev = true },
	},
}
