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
      statusline = require("plugin.config.heirline.statusline"),
      winbar = require("plugin.config.heirline.winbar"),
      tabline = require("plugin.config.heirline.tabline"),
      -- statuscolumn = StatusColumn,
      opts = {
        colors = require("kanagawa.colors").setup(),
      },
    }
  end,
}
