return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  config = true,
  opts = {
    exclude_filetypes = { "netrw", "toggleterm", "oil", "neo-tree" },
    show_modified = true,
  },
}
