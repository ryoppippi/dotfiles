local wezterm = require("wezterm")
local act = wezterm.action

-- ---------------------------------------------------------------
-- --- wezterm keymap
-- ---------------------------------------------------------------
local keys = {
	{ key = "a", mods = "LEADER|CTRL", action = act({ SendString = "\x01" }) },
	{ key = "d", mods = "CMD|SHIFT", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{ key = "d", mods = "CMD", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
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
	--- workspace [[
	{ key = "n", mods = "CMD|SHIFT", action = act.SwitchWorkspaceRelative(1) },
	{ key = "p", mods = "CMD|SHIFT", action = act.SwitchWorkspaceRelative(-1) },
	{
		-- Create new workspace
		key = "S",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "(wezterm) Create new workspace:",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},
	{
		-- Rename workspace
		key = "s",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "(wezterm) Set workspace title:",
			action = wezterm.action_callback(function(win, pane, line)
				if line then
					wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
				end
			end),
		}),
	},
	{
		key = "s",
		mods = "CMD",
		action = wezterm.action_callback(function(win, pane)
			-- create workspace list
			local workspaces = {}
			for i, name in ipairs(wezterm.mux.get_workspace_names()) do
				table.insert(workspaces, {
					id = name,
					label = string.format("%d. %s", i, name),
				})
			end
			-- launch workspace selection
			win:perform_action(
				act.InputSelector({
					action = wezterm.action_callback(function(_, _, id, label)
						if not id and not label then
							wezterm.log_info("Workspace selection canceled") -- 入力が空ならキャンセル
						else
							win:perform_action(act.SwitchToWorkspace({ name = id }), pane) -- workspace を移動
						end
					end),
					title = "Select workspace",
					choices = workspaces,
					fuzzy = true,
					-- fuzzy_description = string.format("Select workspace: %s -> ", current), -- requires nightly build
				}),
				pane
			)
		end),
	},
	-- ]]
	-- added by claude code
	{ key = "Enter", mods = "SHIFT", action = wezterm.action({ SendString = "\x1b\r" }) },
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
