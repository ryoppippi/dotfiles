local plugin_name = "copilot.vim"

local function loading()
  -- vim.api.nvim_command('imap <expr> <Plug>(copilot-dummy-map) copilot#Accept("<Tab>")')
  -- vim.api.nvim_command("imap <silent><script><nowait><expr> <C-l> copilot#Dismiss()")
  -- vim.api.nvim_command('imap <expr> <C-h> copilot#Accept("<CR>")')
  vim.keymap.set("i", "<Plug>(copilot-dummy-map)", [[copilot#Accept"]("<Tab>")]], { expr = true })
  vim.keymap.set("i", "<C-h>", [[copilot#Accept("<CR>")]], { expr = true })
  vim.keymap.set("i", "<C-l>", [[copilot#Dismiss()]], { script = true, nowait = true, expr = true })

  vim.g.copilot_no_tab_map = true
  vim.g.copilot_assume_mapped = true
  vim.g.copilot_tab_fallback = ""
  vim.g.copilot_filetypes = { ["*"] = true }
end

require("utils.plugin").pre_load(plugin_name, loading)
