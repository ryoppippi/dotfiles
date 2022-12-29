return {
  "folke/neoconf.nvim",
  dependencies = { "folke/neodev.nvim" },
  config = function()
    require("neoconf").setup()
  end,
}
