return {
	"skanehira/denops-gh.vim",
	enabled = false,
	dependencies = { "vim-denops/denops.vim" },
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
