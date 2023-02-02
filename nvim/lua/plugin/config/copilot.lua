return {
  {
    "github/copilot.vim",
    event = { "InsertEnter" },
    enabled = true,
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      vim.g.copilot_filetypes = { ["*"] = true }
      -- vim.g.copilot_ignore_node_version = true
      -- vim.g.copilot_node_command = "bun"
    end,
    keys = function()
      local vimx = require("artemis")
      local copilot = vimx.fn.copilot
      return {
        {
          "<Plug>(copilot-dummy-map)",
          function()
            copilot.Accept("<Tab>")
          end,
          mode = "i",
          expr = true,
          desc = "copilot accept",
        },
        {
          "<C-h>",
          function()
            copilot.Accept("<CR>")
          end,
          mode = "i",
          expr = true,
          desc = "copilot accept",
        },
        {
          "<C-l>",
          function()
            copilot.Dismiss()
          end,
          mode = "i",
          script = true,
          nowait = true,
          expr = true,
          desc = "copilot dismiss",
        },
      }
    end,
  },
  {
    "zbirenbaum/copilot.lua",
    enabled = false,
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
