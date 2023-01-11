if not require("utils").is_macos() then
  return
end

vim.opt.clipboard:append("unnamedplus")
