local wezterm = require("wezterm")
local utils = require("utils")
local mux = wezterm.mux

local keys = require("keymaps")

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
	tab_bar_at_bottom = false,
	use_fancy_tab_bar = false,
	force_reverse_video_cursor = true,
	hide_tab_bar_if_only_one_tab = true,
	adjust_window_size_when_changing_font_size = false,
	window_padding = {
		left = 5,
		right = 5,
		top = 0,
		bottom = 0,
	},
	use_ime = true,
	send_composed_key_when_left_alt_is_pressed = false,
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
	macos_forward_to_ime_modifier_mask = "SHIFT|CTRL",

	window_background_opacity = 0.89,
	colors = {},
}

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	local w = window:gui_window()
	w:maximize()
	w:toggle_fullscreen()
end)

config.colors.tab_bar = require("tab_bar")
-- config = utils.merge_tables(config, require("colors.kanagawa_dragon"))
config.color_scheme = "Kimber (base16)"

require("zen-mode")

return utils.merge_tables(config, local_config)
