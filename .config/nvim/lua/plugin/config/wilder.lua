local plugin_name = "wilder"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.api.nvim_exec(
    [[
      call wilder#setup({'modes': [':', '/', '?']})
      call wilder#set_option('renderer', wilder#popupmenu_renderer({
        \ 'highlighter': wilder#basic_highlighter(),
      \ }))
    ]],
    true
  )
end

require("utils.plugin").post_load(plugin_name, loading)
