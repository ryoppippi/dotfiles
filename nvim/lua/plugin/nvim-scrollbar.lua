return {
  "petertriho/nvim-scrollbar",
  event = { "BufReadPre" },
  dependencies = { "kevinhwang91/nvim-hlslens" },
  config = function(_, opts)
    require("scrollbar").setup(opts)
    require("scrollbar.handlers.gitsigns").setup()
  end,
}
