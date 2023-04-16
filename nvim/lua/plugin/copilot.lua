return {
  {
    "github/copilot.vim",
    event = { "InsertEnter" },
    enabled = false,
    dependencies = { "tani/vim-artemis" },
    init = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      vim.g.copilot_filetypes = { ["*"] = true }
    end,
    keys = function()
      return {
        {
          "<Plug>(copilot-dummy-map)",
          function()
            vimx.fn.copilot.Accept("<Tab>")
          end,
          mode = "i",
          expr = true,
          desc = "copilot accept",
        },
        {
          "<C-h>",
          function()
            vimx.fn.copilot.Accept("<CR>")
          end,
          mode = "i",
          expr = true,
          desc = "copilot accept",
        },
        {
          "<C-l>",
          function()
            vimx.fn.copilot.Dismiss()
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
    enabled = true,
    cmd = { "Copilot" },
    event = { "InsertEnter", "CursorHold", "FocusLost" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup({
          suggestion = {
            enabled = false,
            auto_trigger = true,
            keymap = {
              accept = "<Tab>",
              accept_word = false,
              accept_line = false,
              -- next = "<C-S-n>",
              -- prev = "<C-S-p>",
              dismiss = "<C-l>",
            },
          },
        })
      end, 100)
    end,
  },
}
