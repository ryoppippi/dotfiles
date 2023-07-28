return {
	"kosayoda/nvim-lightbulb",
	event = { "LspAttach" },
	opts = function()
		return {
			autocmd = { enabled = true },
			sign = { enabled = false },
			virtual_text = { enabled = true },
		}
	end,
}
