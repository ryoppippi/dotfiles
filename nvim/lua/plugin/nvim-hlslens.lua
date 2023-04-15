return {
  "kevinhwang91/nvim-hlslens",
  dependencies = { "petertriho/nvim-scrollbar" },
  event = { "VeryLazy" },
  config = function(_, opts)
    require("scrollbar.handlers.search").setup(opts)
  end,
}
