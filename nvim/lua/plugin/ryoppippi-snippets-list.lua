---@type LazySpec
return {
	"ryoppippi-snippets-list",
	virtual = true,
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
