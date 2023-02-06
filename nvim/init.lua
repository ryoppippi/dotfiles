require("global")
require("base")
require("options")
require("pack")
require("autocmd")
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    require("command")
    require("keymaps")
    require("macos")
  end,
})
