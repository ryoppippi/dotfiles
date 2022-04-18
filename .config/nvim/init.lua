require("options")
require("autocmd")
require("command")
require("keymaps")

vim.cmd("runtime ./vimrc/plug.vim")

if require("utils").is_macos() then
	require("macos")
end
