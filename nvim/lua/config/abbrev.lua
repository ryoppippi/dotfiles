vim.cmd(
	[[cnoreabbrev <expr> s getcmdtype() .. getcmdline() ==# ':s' ? [getchar(), ''][1] .. "%s//g<Left><Left>" : 's']]
)

vim.keymap.set("ia", "cosnt", "const")
