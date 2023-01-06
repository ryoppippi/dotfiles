local M = {}

function M.load(plugin_name)
  return pcall(vim.cmd.packadd, plugin_name)
end

function M.load_denops_on_lazy(plugin_name)
  return function()
    require("lazy").load({ plugins = { "denops.vim" } })

    local plugins = require("lazy.core.config").plugins
    local plugin = plugins[plugin_name]
    local plugin_denops_dir = plugin.dir .. "/" .. "denops"
    if not tb(vim.fn.isdirectory(plugin_denops_dir)) then
      return
    end
    local candidates = vim.fn.globpath(plugin.dir, "denops/*/main.ts", true, true)
    local to_load = {}
    for _, c in ipairs(candidates) do
      local denops_plugin = vim.fn.fnamemodify(c, ":h:t")
      if not to_load[denops_plugin] then
        local ok, is_loaded = pcall(vim.fn["denops#plugin#is_loaded"], denops_plugin)
        if not ok then
          vim.notify(string.format("%s needs denops.vim to be loaded before itself.", plugin_name), vim.log.levels.WARN)
          return
        end
        if not tb(is_loaded) then
          table.insert(to_load, denops_plugin)
        end
      end
    end
    for _, denops_plugin in ipairs(to_load) do
      if vim.fn["denops#server#status"]() == "running" then
        -- Note: denops#plugin#register() may fail
        pcall(vim.fn["denops#plugin#register"], denops_plugin, { mode = "skip" })
      end
      vim.fn["denops#plugin#wait"](denops_plugin)
    end
  end
end

return M
