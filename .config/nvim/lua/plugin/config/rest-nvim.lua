local plugin_name = "rest-nvim"

local function loading()
  local t = require("utils").t
  local feedkeys = vim.fn.feedkeys
  require(plugin_name).setup({
    -- Open request results in a horizontal split
    result_split_horizontal = false,
    -- Keep the http file buffer above|left when split horizontal|vertical
    result_split_in_place = false,
    -- Skip SSL verification, useful for unknown certificates
    skip_ssl_verification = false,
    -- Highlight request on run
    highlight = {
      enabled = true,
      timeout = 150,
    },
    result = {
      -- toggle showing URL, HTTP info, headers at top the of result window
      show_url = true,
      show_http_info = true,
      show_headers = true,
    },
    -- Jump to request line on run
    jump_to_request = false,
    env_file = ".env",
    custom_dynamic_variables = {},
    yank_dry_run = true,
  })
  vim.api.nvim_create_user_command("RestNvim", function()
    feedkeys(t("<Plug>RestNvim"), "")
  end, { nargs = "*" })
  vim.api.nvim_create_user_command("RestNvimPreview", function()
    feedkeys(t("<Plug>RestNvimPreview"), "")
  end, { nargs = "*" })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
