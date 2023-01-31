local wezterm = require("wezterm")
local utils = require("utils")

-- ---------------------------------------------------------------
-- --- wezterm keymap
-- ---------------------------------------------------------------
local keys = {
  { key = "a", mods = "LEADER|CTRL", action = wezterm.action({ SendString = "\x01" }) },
  { key = "v", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
  {
    key = "g",
    mods = "LEADER",
    action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
  },
  { key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
  { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
  { key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
  { key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
  { key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
  { key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
  { key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
  { key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
  { key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
  { key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
  { key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
  { key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
  { key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
  { key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
  { key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
  { key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
  { key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
  { key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
  { key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
  { key = "&", mods = "LEADER|SHIFT", action = wezterm.action({ CloseCurrentTab = { confirm = true } }) },
  { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
  { key = "Space", mods = "LEADER", action = "QuickSelect" },

  { key = "n", mods = "SHIFT|CTRL", action = "ToggleFullScreen" },
  { key = "v", mods = "SHIFT|CTRL", action = "Paste" },
  { key = "c", mods = "SHIFT|CTRL", action = "Copy" },

  { key = "i", mods = "LEADER", action = wezterm.action({ EmitEvent = "trigger-ide" }) },
}

-- ---------------------------------------------------------------
-- --- wezterm on
-- ---------------------------------------------------------------

-- https://github.com/wez/wezterm/issues/1680
local function update_window_background(window, pane)
  local overrides = window:get_config_overrides() or {}
  -- If there's no foreground process, assume that we are "wezterm connect" or "wezterm ssh"
  -- and use a different background color
  -- if pane:get_foreground_process_name() == nil then
  -- 	-- overrides.colors = { background = "blue" }
  -- 	overrides.color_scheme = "Red Alert"
  -- end

  if pane:get_user_vars().production == "1" then
    overrides.color_scheme = "OneHalfDark"
  end
  window:set_config_overrides(overrides)
end

local function update_tmux_style_tab(window, pane)
  local cwd_uri = pane:get_current_working_dir()
  local cwd = ""
  local hostname = ""
  if cwd_uri then
    cwd_uri = cwd_uri:sub(8)
    local slash = cwd_uri:find("/")
    if slash then
      hostname = cwd_uri:sub(1, slash - 1)
      -- Remove the domain name portion of the hostname
      local dot = hostname:find("[.]")
      if dot then
        hostname = hostname:sub(1, dot - 1)
      end
      if hostname ~= "" then
        hostname = "@" .. hostname
      end
      -- and extract the cwd from the uri
      cwd = utils.convert_home_dir(cwd)
    end
  end
  return {
    { Attribute = { Underline = "Single" } },
    { Attribute = { Italic = true } },
    { Text = cwd .. hostname },
  }
end

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
  use_ime = true,
  font = wezterm.font("UDEV Gothic 35LG"),
  font_size = 15.0,
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
  window_background_opacity = 0.97,
  -- disable_default_key_bindings = true,
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
-- config = utils.merge_tables(config, require("colors.kanagawa"))

return utils.merge_tables(config, local_config)
