return {
  "hrsh7th/vim-vsnip",
  cond = (vim.g.enabled_snippet == "vsnip"),
  dependencies = require("plugin.config.snippets.snippets"),
  init = function()
    vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/my_vscode_snippets/snippets"

    -- vim.g.vsnip_filetypes = {}
    -- vim.g.vsnip_filetypes.javascriptreact = { "javascript" }
    -- vim.g.vsnip_filetypes.typescriptreact = { "typescript" }
  end,
}
