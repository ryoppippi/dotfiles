return {
  "folke/noice.nvim",
  event = "VeryLazy",
  enabled = false,
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = function()
    require("noice").setup({
      popupmenu = {
        enabled = true,
        -- backend = "cmp",
      },
      notify = {
        enabled = true,
      },
      messages = {
        view_search = false,
      },
      presets = {
        inc_rename = true,
      },
    })
  end,
}
