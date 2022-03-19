local status, material = pcall(require, "material")
if (not status) then return end

material.setup()
vim.cmd 'colorscheme material'

