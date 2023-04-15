return {
  "rebelot/heirline.nvim",
  enabled = true,
  cond = vim.o.termguicolors,
  event = "UIEnter",
  dependencies = { "rebelot/kanagawa.nvim" },
  config = function(_, opts)
    require("heirline").setup(opts)
  end,
  opts = function()
    return {
      statusline = require("plugin.heirline.statusline"),
      winbar = require("plugin.heirline.winbar"),
      tabline = require("plugin.heirline.tabline"),
      -- statuscolumn = require("plugin.heirline.statuscolumn"),
      opts = {
        colors = require("kanagawa.colors").setup(),
      },
    }
  end,
}
