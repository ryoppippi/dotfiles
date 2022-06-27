pcall(vim.cmd, "packadd impatient")
pcall(require, "impatient")

require("base")
require("options")
require("display")
require("plugin")
require("keymaps")
require("autocmd")

vim.defer_fn(function()
  require("command")
  require("vscode")
  require("macos")
end, 50)

vim.cmd([[set runtimepath^=~/.ghq/github.com/ryoppippi/luapack.nvim]])
-- require("sqltest")
