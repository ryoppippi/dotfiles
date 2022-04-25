local function setting()
	vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
	vim.cmd([[syntax enable ]])
	vim.cmd([[colorscheme gruvbox-material]])
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = setting,
	nested = true,
	once = true,
})
