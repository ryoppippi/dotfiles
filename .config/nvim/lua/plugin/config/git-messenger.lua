return {
  "rhysd/git-messenger.vim",
  event = "BufReadPost",
  keys = {
    { "<leader>gm", "<Plug>(git-messenger)" },
  },
  init = function()
    vim.g.git_messenger_no_default_mappings = 1
  end,
}
