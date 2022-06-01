local plugin_name = "nvim-pasta"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.keymap.set("n", "p", require("pasta.mappings").p)
  vim.keymap.set("n", "P", require("pasta.mappings").P)

  -- This is the default. You can omit `setup` call if you don't want to change this.
  require("pasta").setup({
    converters = {},
    next_key = vim.api.nvim_replace_termcodes("<C-p>", true, true, true),
    prev_key = vim.api.nvim_replace_termcodes("<C-m>", true, true, true),
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
