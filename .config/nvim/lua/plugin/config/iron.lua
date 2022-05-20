local plugin_name = "iron"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require("iron.core").setup({
    config = {},
    keymaps = {
      send_motion = "<space>sc",
      visual_send = "<space>sc",
      send_line = "<space>sl",
      repeat_cmd = "<space>s.",
      cr = "<space>s<cr>",
      interrupt = "<space>s<space>",
      exit = "<space>sq",
      clear = "<space>cl",
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
