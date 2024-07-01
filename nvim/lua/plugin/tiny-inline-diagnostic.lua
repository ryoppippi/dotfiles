---@type LazySpec
return {
	"https://github.com/rachartier/tiny-inline-diagnostic.nvim",
	event = { "LspAttach" },
	enabled = false,
	opts = {},
	config = function(_, opts)
		vim.diagnostic.config({ virtual_text = false })
		require("tiny-inline-diagnostic").setup(opts)
	end,
}
