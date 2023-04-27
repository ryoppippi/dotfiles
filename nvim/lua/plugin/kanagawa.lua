local DEFUALT_THEME = "wave"
return {
  "rebelot/kanagawa.nvim",
  priority = vim.env.NVIM_COLORSCHEME == "kanagawa" and 1000 or 50,
  lazy = vim.env.NVIM_COLORSCHEME ~= "kanagawa",
  opts = function()
    return {
      overrides = function(colors)
        local theme = colors.theme
        local palette = colors.palette
        return {
          TelescopeTitle = { fg = theme.ui.special, bold = true },
          TelescopePromptNormal = { bg = theme.ui.bg_p1 },
          TelescopePromptBorder = { fg = theme.ui.bg_p1, bg = theme.ui.bg_p1 },
          TelescopeResultsNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m1 },
          TelescopeResultsBorder = { fg = theme.ui.bg_m1, bg = theme.ui.bg_m1 },
          TelescopePreviewNormal = { bg = theme.ui.bg_dim },
          TelescopePreviewBorder = { bg = theme.ui.bg_dim, fg = theme.ui.bg_dim },

          TSRainbowRed = { fg = palette.lotusRed },
          TSRainbowYellow = { fg = palette.lotusYellow },
          TSRainbowBlue = { fg = palette.lotusBlue2 },
          TSRainbowOrange = { fg = palette.lotusOrange },
          TSRainbowGreen = { fg = palette.lotusGreen },
          TSRainbowViolet = { fg = palette.lotusViolet4 },
          TSRainbowCyan = { fg = palette.lotusCyan },
        }
      end,
      globalStatus = true,
      transparent = true,
      theme = DEFUALT_THEME,
    }
  end,
  config = function(_, opts)
    local k = require("kanagawa")
    k.setup(opts)
    k.load(DEFUALT_THEME)
    vim.cmd([[silent KanagawaCompile]])
  end,
}
