return {
	"RRethy/vim-illuminate",
	event = "BufReadPost",
	config = function()
		require("illuminate").configure({
			delay = 500,
			-- lsp only, matching the previous on_attach-per-client behaviour:
			-- buffers without an LSP client stay unhighlighted
			providers = { "lsp" },
		})
	end,
}
