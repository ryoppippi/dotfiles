pcall(vim.cmd, "packadd impatient")
pcall(require, "impatient")

require("options")
require("autocmd")
require("command")
require("keymaps")
require("keymaps_vscode")
require("display")

-- vim.cmd("runtime ./vimrc/plug.vim")
vim.cmd("runtime ./vimrc/plugjetpack.vim")

if require("utils").is_macos() then
	require("macos")
end
