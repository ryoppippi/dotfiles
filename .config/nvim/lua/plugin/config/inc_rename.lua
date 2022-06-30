local tb = require("utils").toboolean
if tb(vim.fn.has("nvim-0.8")) then
  require("inc_rename").setup()
end
