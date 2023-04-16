return {
  "lfilho/cosco.vim",
  enabled = false,
  dependencies = {
    "tpope/vim-repeat",
  },
  keys = {
    { "<leader>;", "<Plug>(cosco-commaOrSemiColon)", mode = { "n" } },
    { ";;", "<c-o><Plug>(cosco-commaOrSemiColon)", mode = { "i" } },
  },
}
