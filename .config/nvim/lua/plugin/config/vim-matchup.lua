local plugin_name = "vim-matchup"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.g.matchup_text_obj_enabled = 1
  vim.g.matchup_matchparen_deferred = 1
  vim.g.matchup_matchparen_deferred_show_delay = 300
  vim.g.matchup_matchparen_deferred_hide_delay = 700
  vim.g.matchup_matchparen_timeout = 300
  vim.g.matchup_matchparen_insert_timeout = 60
  -- vim.keymap.set("o", "%", "]%")
end

local function post_loading()
  vim.api.nvim_clear_autocmds({
    event = { "TextChangedI", "TextChangedP", "TextChanged" },
    group = "matchup_matchparen",
  })
end

loading()
-- require("utils.plugin").post_load(plugin_name, post_loading)
