local trevj = require("trevj")
trevj.setup()
vim.keymap.set("n", "<leader>j", function()
  trevj.format_at_cursor()
end)
