local plugin_name = "auto-session"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function pre_save()
  local _, notify = require("utils.plugin").force_require("notify")
  if notify ~= nil then
    notify.dismiss()
  end
end

local function loading()
  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
  local opts = {
    log_level = "info",
    auto_session_enabled = true,
    auto_session_create_enabled = true,
    auto_save_enabled = true,
    auto_save_restore_enabled = false,
    -- pre_save_cmds = { pre_save },
  }
  require(plugin_name).setup(opts)
end

loading()
