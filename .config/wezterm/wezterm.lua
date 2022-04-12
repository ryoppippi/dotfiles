local wezterm = require 'wezterm';


return {
  use_ime = true,
  font = wezterm.font("UDEV Gothic 35NFLG"),
  font_size = 17.0,
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  colors = {
    background = '#1e2127',
    foreground = '#e6efff',
    ansi = {"#1e2127","#e06c75", "#98c379", "#d19a66", "#61afef", "#c678dd", "#56b6c2", "#828791"},
    brights = {"#5c6370", "#e06c75", "#98c379", "#d19a66", "#61afef", "#c678dd", "#56b6c2", "#e6efff"},
  },
}
