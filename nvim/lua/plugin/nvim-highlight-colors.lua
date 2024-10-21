---@type LazySpec
return {
	"https://github.com/brenoprata10/nvim-highlight-colors",
	cond = not is_vscode(),
	lazy = false,
	opts = {
		render = "virtual",
		enable_tailwind = true,
	},
}
