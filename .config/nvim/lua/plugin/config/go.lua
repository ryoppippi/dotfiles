local plugin_name = "go"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  require(plugin_name).setup()
  vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').gofmt() ]], false)
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
