-- open config
vim.api.nvim_create_user_command("Config", function()
  vim.api.nvim_command("e " .. vim.fn.stdpath("config"))
end, { nargs = 0 })
vim.keymap.set("n", "<leader>.", "<cmd>Config<cr>")

-- custom terminal command
vim.api.nvim_create_user_command("T", "tabe | terminal <args>", { nargs = "*" })

-- indent change
vim.api.nvim_create_user_command("IndentChange", "set tabstop=<args> shiftwidth=<args>", { force = true, nargs = 1 })

vim.api.nvim_create_user_command("EncodingReload", "execute 'e ++enc=<args>'", { force = true, nargs = 1 })

-- count word
vim.api.nvim_create_user_command("CountWord", function()
  local input = vim.fn.input("", "':%s/\\<<C-r><C-w>\\>/&/gn'")
  vim.cmd(input)
  vim.fn.histadd("cmd", input)
end, { force = true })

vim.api.nvim_create_user_command("ToggleStatusBar", function()
  if vim.o.laststatus == 3 then
    vim.opt.laststatus = 0
  else
    vim.opt.laststatus = 3
  end
end, { nargs = 0, force = true })

vim.api.nvim_create_user_command("H", function(tbl)
  local args = tbl.args
  local ok, Popup = pcall(require, "nui.popup")
  if not ok then
    vim.api.nvim_command("tabnew")
    vim.api.nvim_command("setlocal buftype=help")
    vim.api.nvim_command("help " .. args)
  end
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
    buf_options = {
      modifiable = false,
      readonly = true,
      buftype = "help",
    },
  })
  popup:mount()
  vim.api.nvim_command("help " .. args)
  popup:on("BufLeave", function()
    popup:unmount()
  end)
  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })
end, { nargs = "?", complete = "help", force = true })
