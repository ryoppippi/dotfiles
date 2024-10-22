local wezterm = require("wezterm")
local mux = wezterm.mux

wezterm.on("toggle-opacity", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.window_background_opacity then
		overrides.window_background_opacity = 0.6
	else
		overrides.window_background_opacity = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("toggle-blur", function(window, _)
	local overrides = window:get_config_overrides() or {}
	if not overrides.macos_window_background_blur then
		overrides.macos_window_background_blur = 0
	else
		overrides.macos_window_background_blur = nil
	end
	window:set_config_overrides(overrides)
end)

wezterm.on("gui-startup", function(cmd)
	local _, _, window = mux.spawn_window(cmd or {})
	local w = window:gui_window()
	w:maximize()
end)
