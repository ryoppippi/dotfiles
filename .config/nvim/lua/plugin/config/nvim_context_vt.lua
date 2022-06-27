local plugin_name = "nvim_context_vt"

local function loading()
  require("nvim_context_vt").setup({
    enabled = true,
    disable_virtual_lines_ft = {
      "yaml",
      "python",
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
