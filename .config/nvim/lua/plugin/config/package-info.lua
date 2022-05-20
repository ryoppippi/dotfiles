local plugin_name = "package-info"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  pcall(vim.cmd, ("packadd " .. plugin_name))
  local status, pinfo = pcall(require, plugin_name)
  if status then
    require(plugin_name).setup()
  end
end

vim.api.nvim_create_user_command("PackageInfo", function()
  loading()
  require(plugin_name).show()
end, { force = true })
