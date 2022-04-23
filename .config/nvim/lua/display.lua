vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		vim.cmd([[colorscheme onedark]])
	end,
	nested = true,
	once = true,
})
