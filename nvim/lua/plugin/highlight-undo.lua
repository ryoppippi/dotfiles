return {
	{
		"tzachar/highlight-undo.nvim",
		-- BufReadPre rather than VeryLazy: the tracker attaches on
		-- BufEnter/InsertLeave autocmds, and VeryLazy fires after the first
		-- buffer's BufEnter, leaving it untracked until the next one
		event = { "BufReadPre", "BufNewFile" },
		-- setup() must run to install the undo-tracking autocmds;
		-- without opts the spec loads but nothing is highlighted
		opts = {},
	},
}
