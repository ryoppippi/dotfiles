local M = {}

M.is_vscode = function()
  return tb(vim.g.vscode)
end

M.is_macos = function()
  return vim.loop.os_uname().sysname == "Darwin"
end

M.is_event_available = function(event)
  return tb(vim.fn.exists(("##" .. event)))
end

M.merge_tables = function(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      M.merge_tables(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end

M.merge_arrays = function(a1, a2)
  for _, v in ipairs(a2) do
    table.insert(a1, v)
  end
  return a1
end

M.find_cmd = function(cmd, prefixes, start_from, stop_at)
  local path = require("lspconfig.util").path

  if type(prefixes) == "string" then
    prefixes = { prefixes }
  end

  local found
  for _, prefix in ipairs(prefixes) do
    local full_cmd = prefix and path.join(prefix, cmd) or cmd
    local possibility

    -- if start_from is a dir, test it first since transverse will start from its parent
    if start_from and path.is_dir(start_from) then
      possibility = path.join(start_from, full_cmd)
      if vim.fn.executable(possibility) > 0 then
        found = possibility
        break
      end
    end

    path.traverse_parents(start_from, function(dir)
      possibility = path.join(dir, full_cmd)
      if vim.fn.executable(possibility) > 0 then
        found = possibility
        return true
      end
      -- use cwd as a stopping point to avoid scanning the entire file system
      if stop_at and dir == stop_at then
        return true
      end
    end)

    if found ~= nil then
      break
    end
  end

  return found or cmd
end

local function reverse(tbl)
  for i = 1, math.floor(#tbl / 2) do
    local j = #tbl - i + 1
    tbl[i], tbl[j] = tbl[j], tbl[i]
  end
end

function M.get_tail(filename)
  return vim.fn.fnamemodify(filename, ":t")
end

function M.split_filename(filename)
  local nodes = {}
  for parent in string.gmatch(filename, "[^/]+/") do
    table.insert(nodes, parent)
  end
  table.insert(nodes, M.get_tail(filename))
  return nodes
end

function M.reverse_filename(filename)
  local parents = M.split_filename(filename)
  reverse(parents)
  return parents
end

local function same_until(first, second)
  for i = 1, #first do
    if first[i] ~= second[i] then
      return i
    end
  end
  return 1
end

function M.get_unique_filename(filename, other_filenames)
  local rv = ""

  local others_reversed = vim.tbl_map(M.reverse_filename, other_filenames)
  local filename_reversed = M.reverse_filename(filename)
  local same_until_map = vim.tbl_map(function(second)
    return same_until(filename_reversed, second)
  end, others_reversed)

  local max = 0
  for _, v in ipairs(same_until_map) do
    if v > max then
      max = v
    end
  end
  for i = max, 1, -1 do
    rv = rv .. filename_reversed[i]
  end

  return rv
end

function M.get_current_ufn()
  local buffers = vim.fn.getbufinfo()
  local listed = vim.tbl_filter(function(buffer)
    return buffer.listed == 1
  end, buffers)
  local names = vim.tbl_map(function(buffer)
    return buffer.name
  end, listed)
  local current_name = vim.fn.expand("%")
  return M.get_unique_filename(current_name, names)
end

function M.redetect_filetype()
  vim.bo.filetype = vim.bo.filetype
end

function M.repeat_element(x, n)
  local tbl = {}
  for _ = 1, n, 1 do
    table.insert(tbl, x)
  end
  return tbl
end

return M
