return {
  "stevearc/dressing.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
  },
  event = "UIEnter",
  opts = {
    select = {
      telescope = require("telescope.themes").get_cursor({ initial_mode = "normal" }),
    },
  },
}
