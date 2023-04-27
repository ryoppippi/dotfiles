local has = require("core.plugin").has

return {
  "L3MON4D3/LuaSnip",
  dependencies = {
    "tpope/vim-repeat",
    {
      "benfowler/telescope-luasnip.nvim",
      config = function()
        require("telescope").load_extension("luasnip")
      end,
      cond = function()
        has("telescope.nvim")
      end,
    },

    -- {{ snippets
    "craigmac/vim-vsnip-snippets",
    "honza/vim-snippets",
    "rafamadriz/friendly-snippets",

    -- language specific snippets
    -- python
    "cstrap/flask-snippets",
    "cstrap/python-snippets",
    -- zig
    "Metalymph/zig-snippets",
    -- web
    "fivethree-team/vscode-svelte-snippets",
    "xabikos/vscode-javascript",
    -- }}
  },
  config = function()
    require("luasnip")
    require("luasnip.loaders.from_snipmate").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_vscode").lazy_load({ paths = { vim.fn.stdpath("config") .. "/my_vscode_snippets" } })
  end,
}
