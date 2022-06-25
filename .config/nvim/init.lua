pcall(vim.cmd, "packadd impatient")
pcall(require, "impatient")

require("base")
require("options")
require("autocmd")
require("command")
require("keymaps")
require("display")
require("plugin")

require("vscode")
require("macos")
