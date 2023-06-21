local function setInlayHintHL()
	local has_hl, hl = pcall(vim.api.nvim_get_hl_by_name, "LspInlayHint", true)
	if has_hl and (hl["foreground"] or hl["background"]) then
		return
	end

	hl = vim.api.nvim_get_hl_by_name("Comment", true)
	local foreground = string.format("#%06x", hl["foreground"] or 0)
	if #foreground < 3 then
		foreground = ""
	end

	hl = vim.api.nvim_get_hl_by_name("CursorLine", true)
	local background = string.format("#%06x", hl["background"] or 0)
	if #background < 3 then
		background = ""
	end

	vim.api.nvim_set_hl(0, "LspInlayHint", { fg = foreground, bg = background })
end

return {
	on_attach = function(client, bufnr)
		if client.supports_method("textDocument/inlayHint") then
			vim.lsp.buf.inlay_hint(bufnr, true)
			setInlayHintHL()
		end
	end,
}
