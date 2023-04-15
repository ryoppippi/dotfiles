local icons = require("plugin.heirline.icons")

return {
  condition = function()
    return not vim.bo.modifiable or vim.bo.readonly
  end,
  provider = icons.padlock,
  -- hl = hl.ReadOnly,
}
