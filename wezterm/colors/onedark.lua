return {
	force_reverse_video_cursor = true,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.96,
	colors = {
		foreground = "#e6efff",
		background = "#1e2127",

		-- cursor_bg = "#b9bfca",
		-- cursor_fg = "#2e3440",
		-- cursor_border = "#b9bfca",

		-- compose_cursor = "#f0d399",
		--
		-- selection_fg = "#b9bfca",
		-- selection_bg = "#3e4655",
		--
		-- scrollbar_thumb = "#3e4655",
		-- split = "#3e4655",

		ansi = { "#1e2127", "#e06c75", "#98c379", "#d19a66", "#61afef", "#c678dd", "#56b6c2", "#828791" },
		brights = { "#5c6370", "#e06c75", "#98c379", "#d19a66", "#61afef", "#c678dd", "#56b6c2", "#e6efff" },

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
}
