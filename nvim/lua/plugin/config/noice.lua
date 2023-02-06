return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  opts = {
    popupmenu = {
      enabled = true,
      backend = "cmp",
    },
    notify = {
      enabled = true,
      view = "mini",
    },
    cmdline = {
      enabled = true,
    },
    messages = {
      view_search = false,
      view = "mini",
    },
    presets = {
      inc_rename = true,
    },
  },
}
