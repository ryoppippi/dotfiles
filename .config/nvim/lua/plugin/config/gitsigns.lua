local plugin_name = "gitsigns"

local function loading()
  require(plugin_name).setup({
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~_" },
    },
    current_line_blame = true,
    on_attach = function(buffer)
      vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", { silent = true })
      vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { silent = true })
    end,
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
