return {
	"gbprod/substitute.nvim",
	dependencies = {
		-- { "gbprod/yanky.nvim" },
	},
	keys = {
		{ "cx", "<cmd>lua require('substitute').operator()<cr>", mode = "n" },
		{ "cx", "<cmd>lua require('substitute').visual()<cr>", mode = "x" },
		{ "cxc", "<cmd>lua require('substitute').line()<cr>", mode = "n" },
		{ "cX", "<cmd>lua require('substitute').eol()<cr>", mode = "n" },
	},
	config = function()
		require("substitute").setup({
			-- on_substitute = function(event)
			--   local y = require("yanky")
			--   return y.init_ring("p", event.register, event.count, event.vmode:match("[vV�]"))
			-- end,
		})
	end,
}
