---@type LazySpec
return {
	"https://github.com/ray-x/lsp_signature.nvim",
	lazy = false,
	enabled = true,
	opts = {},
	config = function(_, opts)
		require("core.plugin").on_attach(function(client, bufnr)
			require("lsp_signature").on_attach(opts, bufnr)
		end)
	end,
}
