return {
  "skanehira/denops-gh.vim",
  enabled = false,
  dependencies = { "vim-denops/denops.vim" },
  config = function()
    require("denops-lazy").load("denops-gh.vim")
  end,
}
