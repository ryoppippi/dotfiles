return {
	"tani/hey.vim",
	dependencies = { "vim-denops/denops.vim" },
	cmd = { "Hey" },
	event = { "User DenopsReady" },
	config = function()
		require("denops-lazy").load("hey.vim")
	end,
}
