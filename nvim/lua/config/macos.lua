if not require("core.utils").is_macos() then
  return
end

vim.opt.clipboard:append("unnamedplus")
