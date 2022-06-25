vim.keymap.set("n", "<Leader>h", function()
  require("replacer").run()
end, { nowait = true, silent = true, desc = "replacer" })
