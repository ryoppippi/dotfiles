local plugin_name = "iron"

local function loading()
  require("iron.core").setup({
    config = {},
    keymaps = {
      send_motion = "<leader>sc",
      visual_send = "<leader>sc",
      send_line = "<leader>sl",
      send_mark = "<leader>sm",
      mark_motion = "<leader>mc",
      mark_visual = "<leader>mc",
      remove_mark = "<leader>md>",
      cr = "<leader>s<cr>",
      interrupt = "<leader>s<space>",
      exit = "<leader>sq",
      clear = "<leader>cl",
    },
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
