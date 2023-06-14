return {
	{
		"tzachar/highlight-undo.nvim",
		event = "VeryLazy",
		opts = {
			hlgroup = "HighlightUndo",
			duration = 300,
			keymaps = {
				{ "n", "u", "undo", {} },
				{ "n", "<C-r>", "redo", {} },
			},
		},
	},
}
