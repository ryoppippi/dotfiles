return {
  "kosayoda/nvim-lightbulb",
  event = { "LspAttash" },
  config = function()
    require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
  end,
}
