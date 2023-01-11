return {
  "smjonas/live-command.nvim",
  event = "VeryLazy",
  config = function()
    require("live-command").setup({
      commands = {
        Norm = { cmd = "norm" },
      },
    })
  end,
}
