require("stickybuf").setup({
  filetype = {
    toggleterm = "filetype",
    lir = false,
  },
  autocmds = {
    lir = [[au FileType lir UnpinBuffer ]],
  },
})
