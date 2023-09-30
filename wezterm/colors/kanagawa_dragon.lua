return {
	force_reverse_video_cursor = true,
	use_fancy_tab_bar = false,
	window_background_opacity = 0.9,
	colors = {
		force_reverse_video_cursor = true,
		foreground = "#c5c9c5",
		background = "#181616",

		cursor_bg = "#C8C093",
		cursor_fg = "#C8C093",
		cursor_border = "#C8C093",

		selection_fg = "#C8C093",
		selection_bg = "#2D4F67",

		scrollbar_thumb = "#16161D",
		split = "#16161D",

		ansi = { "#0D0C0C", "#C4746E", "#8A9A7B", "#C4B28A", "#8BA4B0", "#A292A3", "#8EA4A2", "#C8C093" },
		brights = { "#A6A69C", "#E46876", "#87A987", "#E6C384", "#7FB4CA", "#938AA9", "#7AA89F", "#C5C9C5" },
		indexed = { [16] = "#B6927B", [17] = "#B98D7B" },

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
