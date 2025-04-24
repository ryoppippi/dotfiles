require("core.plugin").on_attach(function(client, bufnr)
	vim.api.nvim_create_autocmd("BufWritePre", {
		pattern = "*.go",
		callback = function()
			require("go.format").gofmt()
		end,
	})
	require("go").setup({
		luasnip = false,
		lsp_inlay_hints = {
			enable = true,
		},
		lsp_keymaps = false,
	})
end)
