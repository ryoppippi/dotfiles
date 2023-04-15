return {
  "yuki-yano/fuzzy-motion.vim",
  cmd = { "FuzzyMotion" },
  keys = {
    { "<CR>", "<CMD>FuzzyMotion<CR>", mode = { "n", "v", "x" } },
  },
  dependencies = {
    "vim-denops/denops.vim",
    "lambdalisue/kensaku.vim",
  },
  init = function()
    vim.g.fuzzy_motion_matchers = { "fzf", "kensaku" }
  end,
  config = function()
    require("denops-lazy").load("fuzzy-motion.vim")
  end,
}
