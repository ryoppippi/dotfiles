local M = {}
local u = require("utils")

function M.get_jetpack_plugin_event_name(plugin_name)
  local R = {}
  local camelPluginName = vim.fn.substitute(
    vim.fn.substitute(plugin_name, [[\W\+]], [[_]], [[g]]),
    [[\(^\|_\)\(.\)]],
    [[\u\2]],
    [[g]]
  )
  R.pre = "Jetpack" .. camelPluginName .. "Pre"
  R.post = "Jetpack" .. camelPluginName .. "Post"
  return R
end

local function create_event_table(opt, callback)
  local returnOpt = { once = true, nested = true }
  if type(opt) == "table" then
    for _, v in ipairs(opt) do
      table.insert(returnOpt, v)
    end
  end
  if type(callback) == "function" then
    returnOpt.callback = callback
  elseif type(callback) == "string" then
    returnOpt.command = callback
  end
  return returnOpt
end

function M.load(plugin_name)
  return pcall(vim.cmd.packadd, plugin_name)
end

function M.get(plugin_name)
  return require("jetpack").get(plugin_name)
end

function M.names()
  return require("jetpack").names()
end

function M.post_load(plugin_name, callback, opt)
  local optTable = create_event_table(opt, callback)
  optTable.pattern = M.get_jetpack_plugin_event_name(plugin_name).post
  vim.api.nvim_create_autocmd("User", optTable)
end

function M.pre_load(plugin_name, callback, opt)
  local optTable = create_event_table(opt, callback)
  optTable.pattern = M.get_jetpack_plugin_event_name(plugin_name).pre
  vim.api.nvim_create_autocmd("User", optTable)
end

function M.load_denops_plugin(plugin_name, callback)
  vim.api.nvim_create_autocmd("User", {
    pattern = "DenopsPluginPost:" .. plugin_name,
    callback = function()
      callback()
    end,
    once = true,
    nested = true,
  })
end

function M.force_load_on_event(plugin_name, loading_callback)
  local function ce(e)
    local t = {}
    local event = nil
    local pattern = nil
    for v in string.gmatch(e, "%S+") do
      table.insert(t, v)
    end
    event = t[1]
    pattern = t[2] or "*"
    vim.api.nvim_create_autocmd(event, {
      callback = function()
        M.load(plugin_name)
        loading_callback()
      end,
      once = true,
      nested = true,
      pattern = pattern,
    })
  end

  local pkg = require("utils.plugin").get(plugin_name)
  if not pkg then
    return nil
  end
  local event = pkg.on
  local event_table = {}

  if event == nil then
    loading_callback()
    return
  end

  if type(event) == "string" then
    event_table = { event }
  elseif type(event) == "table" then
    event_table = event
  end

  for _, e in ipairs(event_table) do
    if u.is_event_available(e) then
      ce(e)
    end
  end
end

function M.force_require(plugin_name)
  M.load(plugin_name)
  local s, r = pcall(require, plugin_name)
  -- if not s then
  --   vim.api.nvim_echo({ { r, "Error" } }, true, {})
  -- end
  return s and r or nil
end

function M.load_scripts(plugin_name, subdirectory)
  local dir = vim.fn.expand(M.get(plugin_name).path .. subdirectory)
  local fd = vim.loop.fs_scandir(dir)
  if not fd then
    return
  end
  while true do
    local file_name, type = vim.loop.fs_scandir_next(fd)
    if not file_name then
      break
    end
    if type == "file" then
      vim.cmd.source(dir .. "/" .. file_name)
    end
  end
end

return M
