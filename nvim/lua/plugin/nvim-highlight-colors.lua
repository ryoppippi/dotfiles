---@type LazySpec
return {
	"https://github.com/brenoprata10/nvim-highlight-colors",
	cond = not is_vscode(),
	event = "BufReadPost",
	opts = {
		render = "virtual",
		enable_tailwind = true,
	},
}
