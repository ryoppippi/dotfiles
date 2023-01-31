return {
  "folke/noice.nvim",
  event = "VeryLazy",
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  config = {
    popupmenu = {
      enabled = true,
      backend = "cmp",
    },
    notify = {
      enabled = true,
      view = "mini",
    },
    messages = {
      view_search = false,
    },
    presets = {
      inc_rename = true,
    },
  },
}
