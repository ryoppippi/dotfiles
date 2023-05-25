return {
  "utilyre/barbecue.nvim",
  name = "barbecue",
  version = "*",
  event = "VeryLazy",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons", -- optional dependency
  },
  config = true,
  opts = {
    -- configurations go here
    exclude_filetypes = { "netrw", "toggleterm", "oil", "neo-tree" },
  },
}
