local plugin_name = "package-info"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local _, pinfo = require("utils.plugin").force_require(plugin_name)
  pinfo.setup()
end

vim.api.nvim_create_user_command("PackageInfo", function()
  loading()
  require(plugin_name).show()
end, { force = true })
