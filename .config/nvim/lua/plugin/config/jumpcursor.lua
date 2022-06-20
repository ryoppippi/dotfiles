local plugin_name = "jumpcursor"

local function loading()
  -- nmap <silent> <Leader>j <Plug>(jumpcursor-jump)
  vim.keymap.set("n", "<leader>j", "<Plug>(jumpcursor-jump)<CR>", { silent = true })
end

loading()
