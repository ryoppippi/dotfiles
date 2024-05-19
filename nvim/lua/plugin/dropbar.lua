return {
	"Bekaboo/dropbar.nvim",
	event = "VeryLazy",
	cond = not is_vscode(),
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<C-h>",
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
			general = {
				enable = function(buf, win)
					local disable_ft = { "oil" }

					return not vim.api.nvim_win_get_config(win).zindex
						and vim.bo[buf].buftype == ""
						and vim.api.nvim_buf_get_name(buf) ~= ""
						and not vim.tbl_contains(disable_ft, vim.api.nvim_get_option_value("filetype", { buf = buf }))
						and not vim.wo[win].diff
				end,
			},
			sources = {
				path = {
					modified = function(sym)
						return sym:merge({
							name = sym.name,
							icon = " ",
							name_hl = "DiffAdded",
							icon_hl = "DiffAdded",
						})
					end,
				},
			},
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
