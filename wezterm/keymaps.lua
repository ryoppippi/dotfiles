local wezterm = require("wezterm")
local act = wezterm.action

-- ---------------------------------------------------------------
-- --- wezterm keymap
-- ---------------------------------------------------------------
local keys = {
	{ key = "a", mods = "LEADER|CTRL", action = act({ SendString = "\x01" }) },
	{ key = "v", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{
		key = "g",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "W", mods = "CMD|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "z", mods = "CMD", action = act.TogglePaneZoomState },
	{ key = "h", mods = "CMD", action = act.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CMD", action = act.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CMD", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CMD", action = act.ActivatePaneDirection("Right") },
	{ key = "H", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Up", 5 }) },
	{ key = "L", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Right", 5 }) },
	{ key = "(", mods = "CMD|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = ")", mods = "CMD|SHIFT", action = act.MoveTabRelative(1) },
	{ key = "Space", mods = "LEADER", action = act.QuickSelect },
	{ key = ";", mods = "LEADER", action = act.ToggleFullScreen },
	{ key = "f", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-blur") },
	{
		key = "s",
		mods = "CMD|SHIFT",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES", title = "Select workspace" }),
	},
}

-- activate tab
for i = 1, 9 do
	table.insert(keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

-- -- move tab
-- for i = 1, 9 do
--   table.insert(keys, {
--     key = tostring(i),
--     mods = "LEADER|SHIFT",
--     action = act.MoveTab(i - 1),
--   })
-- end

return keys
