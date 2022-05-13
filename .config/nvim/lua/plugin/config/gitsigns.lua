local plugin_name = "gitsigns"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

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
      vim.keymap.set("n", "<leader>gh", "<cmd>Gitsigns preview_hunk<cr>", { silent = true, noremap = true })
      vim.keymap.set("n", "<leader>gd", "<cmd>Gitsigns diffthis<cr>", { silent = true, noremap = true })
    end,
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
