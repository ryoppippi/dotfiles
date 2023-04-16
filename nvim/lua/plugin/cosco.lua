return {
  "lfilho/cosco.vim",
  dependencies = {
    "tpope/vim-repeat",
  },
  keys = {
    { "<leader>;", "<Plug>(cosco-commaOrSemiColon)", mode = { "n" } },
    { ";;", "<c-o><Plug>(cosco-commaOrSemiColon)", mode = { "i" } },
  },
}
