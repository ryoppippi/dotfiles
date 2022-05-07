local plugin_name = "vim-vsnip"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/my_vscode_snippets/snippets"

  vim.g.vsnip_filetypes = {}
  vim.g.vsnip_filetypes.javascriptreact = { "javascript" }
  vim.g.vsnip_filetypes.typescriptreact = { "typescript" }
end

loading()
