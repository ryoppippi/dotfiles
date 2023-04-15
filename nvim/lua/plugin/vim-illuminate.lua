return {
  "RRethy/vim-illuminate",
  init = function()
    vim.g.Illuminate_delay = 500

    local on_attach = require("core.plugin").on_attach
    on_attach(function(client, bufnr)
      require("illuminate").on_attach(client)
    end)
  end,
}
