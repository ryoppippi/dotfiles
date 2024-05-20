---@type LazySpec
return {
	"https://github.com/lambdalisue/vim-fall",
	event = { "User DenopsReady" },
	cmd = "Fall",
	dependencies = {
		"vim-denops/denops.vim",
	},
	config = function()
		require("denops-lazy").load("fall")
	end,
}
