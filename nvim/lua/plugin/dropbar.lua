return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	cond = tb(vim.fn.has("nvim-0.10")),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<Leader>s",
			function()
				require("dropbar.api").pick()
			end,
		},
	},
	opts = function()
		local function close_menu()
			local menu = require("dropbar.api").get_current_dropbar_menu()
			if not menu then
				return
			end
			local parent_menu = menu.parent_menu
			if parent_menu then
				parent_menu:close()
			else
				menu:close()
			end
		end

		return {
			menu = {
				keymaps = {
					["h"] = "<C-w>c",
					["l"] = function()
						local menu = require("dropbar.api").get_current_dropbar_menu()
						if not menu then
							return
						end
						local cursor = vim.api.nvim_win_get_cursor(menu.win)
						local component = menu.entries[cursor[1]]:first_clickable(cursor[2])
						if component then
							menu:click_on(component, nil, 1, "l")
						end
					end,
					["<ESC>"] = close_menu,
					["q"] = close_menu,
				},
			},
			bar = {
				pick = {
					pivots = "asdfghjklzxcvbnm,./qwertyuiop",
				},
			},
		}
	end,
}
