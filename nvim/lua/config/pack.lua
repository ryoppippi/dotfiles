require("core.plugin").init()
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
  vim.env.NVIM_COLORSCHEME = "kanagawa"
end

-- vim.g.enabled_snippet = "vsnip"
vim.g.enabled_snippet = "luasnip"

-- load plugins
lazy.setup("plugin.config", {
  defaults = { lazy = true },
  install = { missing = true, colorscheme = { "kanagawa" } },
  checker = { enabled = false },
  concurrency = 16,
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
