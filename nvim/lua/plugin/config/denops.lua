return {
  dir = "~/ghq/github.com/ryoppippi/bunsetsu-wb.vim",
  dependencies = {
    { dir = "~/ghq/github.com/ryoppippi/bunsetsu.vim" },
    { "vim-denops/denops.vim" },
    { "yuki-yano/denops-lazy.nvim" },
  },
  lazy = false, --おはよう;w
  init = function()
    -- vim.cmd([[let g:denops#debug = 1 ]])
  end,
}
