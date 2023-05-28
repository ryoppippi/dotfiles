return {
	"haya14busa/vim-asterisk",
	dependencies = {
		{ "tani/vim-artemis" },
	},
	keys = {
		{ "*", [[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]] },
		{ "#", "<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>" },
		{ "g*", "<Plug>(asterisk-zg*)<Cmd>lua require('hlslens').start()<CR>" },
		{ "g#", "<Plug>(asterisk-zg#)<Cmd>lua require('hlslens').start()<CR>" },
	},
}
