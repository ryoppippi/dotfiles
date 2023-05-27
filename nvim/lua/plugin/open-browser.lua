return {
	"tyru/open-browser.vim",
	event = { "VeryLazy" },
	keys = {
		{ "<Leader>b", "<Plug>(openbrowser-smart-search)", mode = { "n", "v" } },
	},
	dependencies = {
		"tyru/open-browser-github.vim",
		"tyru/open-browser-unicode.vim",
	},
}
