return {
  "skanehira/denops-docker.vim",
  event = { "User DenopsReady" },
  dependencies = { "vim-denops/denops.vim" },
  config = function()
    require("denops-lazy").load("denops-docker.vim")
  end,
}
