return {
	"skanehira/denops-graphql.vim",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function()
		require("denops-lazy").load("denops-graphql.vim")
	end,
}
