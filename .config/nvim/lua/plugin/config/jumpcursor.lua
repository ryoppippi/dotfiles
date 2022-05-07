local plugin_name = "jumpcursor"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  -- nmap <silent> <Leader>j <Plug>(jumpcursor-jump)
  vim.keymap.set("n", "<leader>j", "<Plug>(jumpcursor-jump)<CR>", { silent = true })
end

loading()
