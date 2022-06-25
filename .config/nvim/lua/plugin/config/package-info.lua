local plugin_name = "package-info"

local function loading()
  local pinfo = require("utils.plugin").force_require(plugin_name)
  return pinfo and pinfo.setup()
end

vim.api.nvim_create_user_command("PackageInfo", function()
  loading()
  require(plugin_name).show()
end, { force = true })
