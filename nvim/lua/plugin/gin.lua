return {
  "lambdalisue/gin.vim",
  event = "VeryLazy",
  enabled = false,
  dependencies = { "vim-denops/denops.vim" },
  config = function()
    require("denops-lazy").load("gin.vim")
  end,
}
