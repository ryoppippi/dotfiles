require("lsp_lines").setup()
vim.diagnostic.config({
  virtual_lines = false,
  virtual_text = false,
})

vim.keymap.set("", "<Leader>l", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
