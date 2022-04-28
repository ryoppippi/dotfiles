local plugin_name = "auto-session"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function enable_minimap()
  if vim.g.loaded_minimap then
    vim.api.nvim_command("Minimap")
  end
end

local function disable_minimap()
  if vim.g.loaded_minimap then
    vim.api.nvim_command("Minimap close")
  end
end

local function loading()
  vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"
  local opts = {
    log_level = "info",
    auto_session_enabled = true,
    auto_session_create_enabled = true,
    auto_save_enabled = true,
    auto_save_restore_enabled = true,
    -- pre_save_cmds = {"{vim_cmd_1}", disable_minimap, "{vim_cmd_2}"},
    -- post_save_cmds = {"{vim_cmd_1}", enable_minimap, "{vim_cmd_2}"},
    -- post_restore = {"{vim_cmd_1}", enable_minimap, "{vim_cmd_2}"},
  }
  require(plugin_name).setup(opts)
end

loading()
