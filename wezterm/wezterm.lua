local wezterm = require("wezterm")

local utils = require("utils")
local keys = require("keymaps")
require("on")

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
	show_new_tab_button_in_tab_bar = false,
	adjust_window_size_when_changing_font_size = false,

	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},

	window_background_opacity = 0.80,
	macos_window_background_blur = 15,
	window_decorations = "RESIZE",
	window_background_gradient = {
		colors = { "#000000" },
	},

	colors = {
		tab_bar = {
			inactive_tab_edge = "none",
		},
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
}

config.colors.tab_bar = require("tab_bar")
config = utils.merge_tables(config, require("colors.kanagawa_dragon"))
-- config.color_scheme = "Kimber (base16)"

require("zen-mode")

return utils.merge_tables(config, local_config)
