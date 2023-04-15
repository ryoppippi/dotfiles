return {
  "ryoppippi/bad-apple.vim",
  branch = "main",
  cmd = "BadApple",
  dependencies = { "vim-denops/denops.vim" },
  config = function()
    require("denops-lazy").load("bad-apple.vim")
  end,
}
