require("global")
require("base")
require("options")
require("display")
require("plugin/lazy")
require("autocmd")
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("command")
    require("keymaps")
    require("vscode")
    require("macos")
  end,
})
