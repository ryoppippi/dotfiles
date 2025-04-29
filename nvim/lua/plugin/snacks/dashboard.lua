---@class snacks.dashboard.Config
return {
	sections = {
		{ section = "header" },
		{ icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
		{ icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
		{ icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
		{ section = "startup" },
	},
	autokeys = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
	preset = {
		keys = {
			{ icon = "", desc = "New file", key = "e", action = ":enew" },
			{ icon = "󰒲", desc = "Lazy", key = "z", action = ":Lazy" },
			{ icon = "󰈙", desc = "Oil", key = ".", action = ":Oil" },
			{ icon = "", desc = "Dotfiles", key = "d", action = ":Config" },
			{ icon = "󰈙", desc = "Files", key = "f", action = ":Telescope smart_open" },
			{ icon = "", desc = "Restore Session", key = "s", section = "session" },
			{ icon = "󰅚", desc = "Quit", key = "q", action = ":qa" },
		},
		header = [[
  ___     ___    ___   __  __ /\_\    ___ ___    
 / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\  
/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \ 
\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\
 \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/ ]],
	},
}
