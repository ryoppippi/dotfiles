local M = {}

M.on_attach = function(client, bufnr)
	if client:supports_method("textDocument/foldingRange") then
		local win = vim.api.nvim_get_current_win()
		vim.wo[win][0].foldmethod = "expr"
		vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
	end
end

return M
