pcall(vim.cmd, "packadd impatient")
pcall(require, "impatient")

require("options")
require("keymaps")
require("keymaps_vscode")
require("autocmd")
require("command")
require("display")
require("plugin")

if require("utils").is_macos() then
  require("macos")
end
