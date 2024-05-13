---@type LazySpec
return {
	"skanehira/denops-graphql.vim",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim" },
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
