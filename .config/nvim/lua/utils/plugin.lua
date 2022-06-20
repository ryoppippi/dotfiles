local M = {}
local u = require("utils")
local toboolean = u.toboolean
local jp = require("jetpack")

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
  return pcall(vim.cmd, string.format("packadd %s", plugin_name))
end

 function M.is_exists(plugin_name)
   return toboolean(jp.tap(plugin_name))
 end

function M.get(plugin_name)
  return jp.get(plugin_name)
end

function M.names()
  return jp.names()
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

function M.force_load_on_event(name, loading_callback)
  local function ce(event)
    vim.api.nvim_create_autocmd(event, {
      callback = function()
        M.load(name)
        loading_callback()
      end,
      once = true,
      nested = true,
    })
  end

  local pkg = require("utils.plugin").get(name)
  if not pkg then
    return nil
  end
  local event = pkg.on
  if type(event) == "string" and u.is_event_available(event) then
    ce(event)
  elseif type(event) == "table" then
    ce(event)
  elseif event == nil then
    loading_callback()
  end
end

function M.force_require(plugin_name)
  M.load(plugin_name)
  return pcall(require, plugin_name)
end

return M
