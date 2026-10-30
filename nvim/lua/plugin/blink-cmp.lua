return {
	"saghen/blink.cmp",
	version = "1.*",
	event = "CmdlineEnter",
	cond = not is_vscode(),
	opts = {
		enabled = function()
			return false
		end,
		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			sources = { "buffer", "cmdline" },
			completion = {
				menu = { auto_show = true },
				list = {
					selection = { preselect = false, auto_insert = true },
				},
			},
		},
	},
}
