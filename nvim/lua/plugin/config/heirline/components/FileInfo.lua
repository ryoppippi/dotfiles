local icons = require("plugin.config.heirline.icons")

return {
  condition = function()
    return vim.bo.modified
  end,
  provider = icons.circle,
  hl = function()
    return { fg = "cyan", bold = true, force = true }
  end,
}
