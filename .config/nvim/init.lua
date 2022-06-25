pcall(vim.cmd, "packadd impatient")
pcall(require, "impatient")

require("base")
require("options")
require("autocmd")
require("command")
require("plugin")
require("keymaps")
require("display")

require("vscode")
require("macos")

