local plugin_name = "nvim_context_vt"

local function loading()
  local vt_status, nvim_context_vt = pcall(require, "nvim_context_vt")
  if vt_status then
    nvim_context_vt.setup({
      enabled = true,
      disable_virtual_lines_ft = {
        "yaml",
        "python",
      },
    })
  end
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
