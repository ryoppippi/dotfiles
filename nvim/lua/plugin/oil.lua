return {
  "stevearc/oil.nvim",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  keys = {
    {
      "<leader>e",
      function()
        -- curerent directory
        local cd = vim.fn.expand("%:p:h")

        require("oil").open_float(cd)
      end,
    },
  },
  opts = {
    keymaps = {
      ["g?"] = "actions.show_help",
      ["<CR>"] = "actions.select",
      ["-"] = "actions.parent",
      ["<C-p>"] = "actions.preview",
      ["q"] = "actions.close",
      ["<C-l>"] = "actions.refresh",
      ["<space>"] = "actions.open_cwd",
      ["`"] = "actions.cd",
      ["~"] = "actions.tcd",
      ["g."] = "actions.toggle_hidden",
      -- ["<C-s>"] = "actions.select_vsplit",
      -- ["<C-h>"] = "actions.select_split",
      -- ["<C-t>"] = "actions.select_tab",
    },
    view_options = {
      show_hidden = true,
    },
    use_default_keymaps = false,
  },
  config = function(_, opts)
    require("oil").setup(opts)
  end,
}
