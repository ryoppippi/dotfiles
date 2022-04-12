local status, lsp_signature = pcall(require, "lsp_signature")
if not status then
	return
end

lsp_signature.setup({
	-- floating_window_above_first = true,
	-- zindex = 1,
	hint_enable = false,
})
