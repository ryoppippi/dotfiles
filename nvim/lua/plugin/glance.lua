return {
	"dnlhc/glance.nvim",
	cmd = { "Glance" },
	opts = function()
		return {
			border = { enable = true },
			list = { position = "left" },
			folds = { folded = false },
			hooks = {
				before_open = function(results, open, jump, method)
					if #results == 1 then
						jump(results[1])
					else
						open(results)
					end
				end,
			},
		}
	end,
	config = true,
}
