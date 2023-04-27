require("core.plugin").init()
local lazy = require("lazy")

if vim.env.NVIM_COLORSCHEME == nil then
  vim.env.NVIM_COLORSCHEME = "kanagawa"
end

-- load plugins
lazy.setup("plugin", {
  defaults = { lazy = true },
  install = { missing = true, colorscheme = { "kanagawa" } },
  checker = { enabled = false },
  concurrency = 64,
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
