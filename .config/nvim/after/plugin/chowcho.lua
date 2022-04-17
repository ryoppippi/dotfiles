local status, chowcho = pcall(require, "chowcho")
if not status then
	return
end

vim.api.nvim_set_keymap("n", "<Leader>wq", ":Chowcho<CR>", { noremap = true, silent = true })
