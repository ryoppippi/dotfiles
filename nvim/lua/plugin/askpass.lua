return {
  "lambdalisue/askpass.vim",
  event = { "User DenopsReady" },
  config = function()
    require("denops-lazy").load("askpass.vim")
  end,
}
