---@type LazySpec
return {
	"ryoppippi/vim-ray-so",
	dev = true,
	event = { "User DenopsReady" },
	dependencies = {
		"vim-denops/denops.vim",
	},
	init = function()
		-- vim.g["denops#debug"] = 1
		vim.g.ray_so_theme = "supabase"
	end,
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
