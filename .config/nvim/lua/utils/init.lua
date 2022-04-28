local M = {}

function M.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

function M.is_vscode()
  return M.toboolean(vim.g.vscode)
end

function M.is_macos()
  return vim.loop.os_uname().sysname == "Darwin"
end

function M.toboolean(value)
  if value == nil then
    return false
  elseif type(value) == "boolean" then
    return value
  elseif type(value) == "number" then
    return value ~= 0
  elseif type(value) == "string" then
    return string.lower(value) == "true"
  end
end

function M.is_event_available(event)
  return M.toboolean(vim.fn.exists(("##" .. event)))
end

return M
