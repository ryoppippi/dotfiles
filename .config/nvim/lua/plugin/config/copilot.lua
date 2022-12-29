return {
  "github/copilot.vim",
  event = { "InsertEnter" },
  init = function()
    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    vim.g.copilot_filetypes = { ["*"] = true }
    -- vim.g.copilot_ignore_node_version = true
    -- vim.g.copilot_node_command = "bun"
  end,
  keys = {
    { "<Plug>(copilot-dummy-map)", [[copilot#Accept"]("<Tab>")]], mode = "i", expr = true },
    { "<C-h>", [[copilot#Accept("<CR>")]], mode = "i", expr = true },
    { "<C-l>", [[copilot#Dismiss()]], mode = "i", script = true, nowait = true, expr = true },
  },
}
