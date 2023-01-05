return {
  "zdcthomas/medit",
  keys = {
    { "<leader>q", "<Plug>MEdit" },
  },
  init = function()
    vim.g.medit_no_mapping = 1
  end,
}
