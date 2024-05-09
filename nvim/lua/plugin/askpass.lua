return {
	"lambdalisue/vim-askpass",
	event = { "User DenopsReady" },
	config = function()
		require("denops-lazy").load("vim-askpass")
	end,
}
