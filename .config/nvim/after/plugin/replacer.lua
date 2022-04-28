local status, replacer = pcall(require, "replacer")
if not status then
  return
end

vim.api.nvim_set_keymap(
  "n",
  "<Leader>h",
  ':lua require("replacer").run()<cr>',
  { nowait = true, noremap = true, silent = true }
)
