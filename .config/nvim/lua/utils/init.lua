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
  else
    return false
  end
end

function M.is_event_available(event)
  return M.toboolean(vim.fn.exists(("##" .. event)))
end

function M.merge_tables(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      M.merge_tables(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

return M
