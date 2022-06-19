local plugin_name = "notify"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require("notify").setup({
    -- Icons for the different levels
    icons = {
      ERROR = "",
      WARN = "",
      INFO = "",
      DEBUG = "",
      TRACE = "✎",
    },
    timeout = 1000,
    render = "minimal",
  })
  vim.notify = function(msg, ...)
    if msg:match("%[lspconfig%]") then
      return
    end

    if msg:match("warning: multiple different client offset_encodings") then
      return
    end

    if msg:match("navic") then
      print(msg)
      return
    end

    require("notify")(msg, ...)
  end
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
