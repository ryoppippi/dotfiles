---@type LazySpec
return {
	"lambdalisue/vim-askpass",
	event = { "User DenopsReady" },
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
