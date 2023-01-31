return {
  {
    "github/copilot.vim",
    event = { "InsertEnter" },
    enabled = false,
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      vim.g.copilot_filetypes = { ["*"] = true }
      -- vim.g.copilot_ignore_node_version = true
      -- vim.g.copilot_node_command = "bun"
    end,
    keys = {
      { "<Plug>(copilot-dummy-map)", [[copilot#Accept"]("<Tab>")]], mode = "i", expr = true },
      { "<C-h>", [[copilot#Accept("<CR>")]], mode = "i", expr = true },
      { "<C-l>", [[copilot#Dismiss()]], mode = "i", script = true, nowait = true, expr = true },
    },
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cmd = { "Copilot" },
    event = "InsertEnter",
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          suggestion = {
            auto_trigger = true,
            keymap = {
              accept = "<Tab>",
              accept_word = false,
              accept_line = false,
              next = "<C-S-n>",
              prev = "<C-S-p>",
              dismiss = "<C-l>",
            },
          },
        })
      end, 100)
    end,
  },
}
