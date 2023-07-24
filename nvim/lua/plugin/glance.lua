return {
	"dnlhc/glance.nvim",
	cmd = { "Glance" },
	opts = function()
		local glance = require("glance")
		return {
			border = { enable = true },
			list = { position = "left" },
			folds = { folded = false },
			mappings = {
				list = {
					["<C-s>"] = glance.actions.jump_split,
					["<C-v>"] = glance.actions.jump_vsplit,
				},
			},
			hooks = {
				before_open = function(results, open, jump, method)
					local uri = vim.uri_from_bufnr(0)
					if #results == 1 then
						local target_uri = results[1].uri or results[1].targetUri

						if target_uri == uri then
							jump(results[1])
						else
							open(results)
						end
					else
						open(results)
					end
				end,
			},
		}
	end,
	config = true,
}
