-- open config
vim.api.nvim_create_user_command("Config", function()
  vim.cmd.e(vim.fn.stdpath("config"))
end, { nargs = 0 })
vim.keymap.set("n", "<leader>.", vim.cmd.Config, { desc = "Config" })

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

-- help
vim.api.nvim_create_user_command("H", function(tbl)
  local args = tbl.args
  local Popup = require("utils.plugin").force_require("nui.popup")
  if not Popup then
    vim.cmd.tabnew()
    vim.bo.buftype = "help"
    vim.cmd.help(args)
    return
  end
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    relative = "editor",
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
  vim.cmd.help(args)
  popup:on("BufLeave", function()
    popup:unmount()
  end)
  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })
end, { nargs = "?", complete = "help", force = true })

-- terminal
vim.api.nvim_create_user_command("T", function(tbl)
  local args = tbl.args
  local tf = vim.cmd.terminal
  vim.cmd.tabe()
  if args == "" then
    tf()
  else
    tf(args)
  end
end, { nargs = "*" })
