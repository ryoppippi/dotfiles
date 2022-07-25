local jp = require("jetpack")

vim.api.nvim_create_user_command("JetpackOpenURL", function(tbl)
  local url = jp.get(tbl.args).url
  vim.api.nvim_command("!open " .. url)
end, {
  nargs = 1,
  complete = function()
    return jp.names()
  end,
})

vim.api.nvim_create_user_command("JetpackReadme", function(tbl)
  local path = jp.get(tbl.args).path .. "/readme.md"
  local bufnr = vim.fn.bufadd(path)
  local Popup = require("utils.plugin").force_require("nui.popup")
  if not Popup then
    vim.api.nvim_command("e " .. path)
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
    bufnr = bufnr,
    buf_options = {
      modifiable = false,
      readonly = true,
    },
  })
  popup:mount()
  vim.api.nvim_set_current_buf(bufnr)
  popup:on("BufLeave", function()
    popup:unmount()
  end)
  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })
end, {
  nargs = 1,
  complete = function()
    return jp.names()
  end,
})

vim.api.nvim_create_user_command("JetpackConfig", function(tbl)
  local name = tbl.args
  local config_path = vim.fn.stdpath("config") .. "/lua/plugin/config/" .. name .. ".lua"
  if tb(vim.fn.filereadable(config_path)) then
    vim.api.nvim_command("tabe | edit " .. config_path)
  else
    vim.api.nvim_echo({ { "No config file found for " .. name, "WarningMsg" } }, true, {})
  end
end, {
  nargs = 1,
  complete = function()
    return jp.names()
  end,
})
