local status, modes = pcall(require, "modes")
if not status then return end
vim.opt.cursorline = true
modes.setup()
