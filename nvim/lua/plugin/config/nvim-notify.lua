return {
  "rcarriga/nvim-notify",
  enabled = false,
  lazy = false,
  config = function()
    require("notify").setup({
      -- Icons for the different levels
      icons = {
        ERROR = "",
        WARN = "",
        INFO = "",
        DEBUG = "",
        TRACE = "✎",
      },
      timeout = 500,
      render = "minimal",
      background_colour = "#000000",
    })

    local ignore_messages = {
      "%[lspconfig%]",
      "warning: multiple different client offset_encodings",
      "written",
    }

    vim.notify = function(msg, ...)
      for m in pairs(ignore_messages) do
        if msg:match(m) then
          return
        end
      end

      require("notify")(msg, ...)
    end
  end,
}
