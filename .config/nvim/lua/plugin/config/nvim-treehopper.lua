local function loading()
  local tsht = require("tsht")
  vim.keymap.set("o", "m", function()
    tsht.nodes()
  end, { remap = true, silent = false })
  vim.keymap.set("x", "m", function()
    tsht.nodes()
  end, { silent = false })
end

loading()
