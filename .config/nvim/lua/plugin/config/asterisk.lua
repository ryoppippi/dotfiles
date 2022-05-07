local plugin_name = "asterisk"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

-- map *   <Plug>(asterisk-*)
-- map #   <Plug>(asterisk-#)
-- map g*  <Plug>(asterisk-g*)
-- map g#  <Plug>(asterisk-g#)
-- map z*  <Plug>(asterisk-z*)
-- map gz* <Plug>(asterisk-gz*)
-- map z#  <Plug>(asterisk-z#)
-- map gz# <Plug>(asterisk-gz#)
vim.keymap.set("", "*", "<Plug>(asterisk-*)")
vim.keymap.set("", "#", "<Plug>(asterisk-#)")
vim.keymap.set("", "g*", "<Plug>(asterisk-g*)")
vim.keymap.set("", "g#", "<Plug>(asterisk-g#)")
vim.keymap.set("", "z*", "<Plug>(asterisk-z*)")
vim.keymap.set("", "gz*", "<Plug>(asterisk-gz*)")
vim.keymap.set("", "z#", "<Plug>(asterisk-z#)")
vim.keymap.set("", "gz#", "<Plug>(asterisk-gz#)")
