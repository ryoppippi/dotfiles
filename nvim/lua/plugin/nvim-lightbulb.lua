return {
  "kosayoda/nvim-lightbulb",
  event = { "LspAttach" },
  enabled = false,
  config = function()
    require("nvim-lightbulb").setup({ autocmd = { enabled = true } })
  end,
}
