local status, nvim_autopairs = pcall(require, "nvim-autopairs")
if not status then
	return
end

nvim_autopairs.setup({})
