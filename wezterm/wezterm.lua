local wezterm = require("wezterm")
local utils = require("utils")
local mux = wezterm.mux
local act = wezterm.action

-- ---------------------------------------------------------------
-- --- wezterm keymap
-- ---------------------------------------------------------------
local keys = {
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
	{ key = "v", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
	{
		key = "g",
		mods = "LEADER",
		action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{ key = "t", mods = "CMD", action = wezterm.action.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "x", mods = "LEADER", action = wezterm.action.CloseCurrentPane({ confirm = true }) },
	{ key = "W", mods = "CMD|SHIFT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "z", mods = "CMD", action = act.TogglePaneZoomState },
	{ key = "h", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "j", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Down") },
	{ key = "k", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Up") },
	{ key = "l", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
	{ key = "H", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "J", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "K", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },
	{ key = "L", mods = "CMD|SHIFT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "(", mods = "CMD|SHIFT", action = act.MoveTabRelative(-1) },
	{ key = ")", mods = "CMD|SHIFT", action = act.MoveTabRelative(1) },
	{ key = "Space", mods = "LEADER", action = act.QuickSelect },
	{ key = ";", mods = "LEADER", action = act.ToggleFullScreen },
	-- { key = "v", mods = "SHIFT|CTRL", action = act.PasteFrom("Clipboard") },
	-- { key = "c", mods = "SHIFT|CTRL", action = "Copy" },
	{ key = "f", mods = "CMD|SHIFT", action = act.EmitEvent("toggle-opacity") },
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

-- ---------------------------------------------------------------
-- --- wezterm on
-- ---------------------------------------------------------------
wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.6
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

--
---------------------------------------------------------------
--- load local_config
---------------------------------------------------------------
-- Write settings you don't want to make public, such as ssh_domains
local function load_local_config()
	local ok, re = pcall(require, "local")
	if not ok then
		return {}
	end
	return re.setup()
end

local local_config = load_local_config()

local config = {
	font = wezterm.font("UDEV Gothic 35LG"),
	font_size = 13.0,
	color_scheme = "onedark",
	color_scheme_dirs = { "$HOME/.config/wezterm/colors/" },
	colors = {
		tab_bar = {
			background = "#1b1f2f",
			active_tab = {
				bg_color = "#444b71",
				fg_color = "#c6c8d1",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab = {
				bg_color = "#282d3e",
				fg_color = "#c6c8d1",
				intensity = "Normal",
				underline = "None",
				italic = false,
				strikethrough = false,
			},
			inactive_tab_hover = {
				bg_color = "#1b1f2f",
				fg_color = "#c6c8d1",
				intensity = "Normal",
				underline = "None",
				italic = true,
				strikethrough = false,
			},
			new_tab = {
				bg_color = "#1b1f2f",
				fg_color = "#c6c8d1",
				italic = false,
			},
			new_tab_hover = {
				bg_color = "#444b71",
				fg_color = "#c6c8d1",
				italic = false,
			},
		},
	},
	tab_bar_at_bottom = false,
	use_fancy_tab_bar = false,
	hide_tab_bar_if_only_one_tab = true,
	adjust_window_size_when_changing_font_size = false,
	window_padding = {
		left = 5,
		right = 5,
		top = 0,
		bottom = 0,
	},
	window_background_opacity = 0.96,
	use_ime = true,
	send_composed_key_when_left_alt_is_pressed = true,
	send_composed_key_when_right_alt_is_pressed = false,
	keys = keys,
	set_environment_variables = {},
	-- keys = create_keybinds(),
	leader = { key = ";", mods = "CTRL" },
	enable_csi_u_key_encoding = true,
	unix_domains = {
		{

			name = "unix",
		},
	},
}

wezterm.on("gui-startup", function(cmd)
	local tab, pane, window = mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)
-- config = utils.merge_tables(config, require("colors.kanagawa"))

return utils.merge_tables(config, local_config)
