local plugin_name = "Comment"
local plug_utils = require("utils.plugin")

local function loading()
  for _, path in ipairs(vim.fn.glob(vim.fn.expand(plug_utils.get(plugin_name).path .. "/after/plugin/*"), 1, 1, 1)) do
    vim.cmd("source " .. path)
  end

  require(plugin_name).setup({
    pre_hook = function(ctx)
      -- Only calculate commentstring for tsx filetypes
      if vim.bo.filetype == "typescriptreact" then
        local U = require("Comment.utils")

        -- Determine whether to use linewise or blockwise commentstring
        local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"

        -- Determine the location where to calculate commentstring from
        local location = nil
        if ctx.ctype == U.ctype.block then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end

        return require("ts_context_commentstring.internal").calculate_commentstring({
          key = type,
          location = location,
        })
      end
    end,
  })
end
require("utils.plugin").force_load_on_event(plugin_name, loading)
