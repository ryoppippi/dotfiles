vim.g.jetpack_copy_method = "symlink"
vim.g.jetpack_optimization = 1
vim.g.jetpack_njobs = 16

-- check if jetpack is installed
local status, _ = load("vim-jetpack")
if not tb(status) then
  local dir = vim.fn.expand(vim.fn.stdpath("data") .. "/site/pack/jetpack/opt/vim-jetpack")
  if not tb(vim.fn.isdirectory(dir)) then
    local url = "https://github.com/tani/vim-jetpack"
    vim.cmd(string.format("!git clone %s %s", url, dir))
  end
  load("vim-jetpack")
end

local jp = require("jetpack")
local jp_packer = require("jetpack.packer")

local plugin_list = require("plugin")

for i, v in ipairs(plugin_list) do
  plugin_list[i].as = v.as or vim.fn.fnamemodify(v[1], ":t:r")
end

-- for i, v in ipairs(plugin_list) do
--   local function get_conf(conf)
--     if type(conf) == "string" then
--       return { conf }
--     end
--     conf.as = conf.as or conf.name or vim.fn.fnamemodify(conf[1], ":t:r")
--     conf.name = conf.as
--     conf.config = function()
--       pcall(require, "plugin/config/" .. conf.as)
--     end
--     return conf
--   end
--   plugin_list[i] = get_conf(v)
--   if plugin_list[i].dependencies ~= nil then
--     for j, d in ipairs(plugin_list[i].dependencies) do
--       plugin_list[i].dependencies[j] = get_conf(d)
--     end
--   end
-- end

local startup_list = {
  "auto-session",
  "copilot",
  "vim-sonictemplate",
  "vim-searchx",
  "nvim-treesitter",
  "telescope",
  "todo-comments",
  "feline",
  "bufferline",
  "mason",
  "mason-lspconfig",
  "noice",
  "kanagawa",
}

local vim_enter_list = {
  -- "xbase",
}

local my_plugin_list = {}

-- load plugins
jp_packer.startup(function(use)
  for _, plugin in ipairs(plugin_list) do
    local enabled = plugin.enabled
    if enabled ~= false then
      use(plugin)
    end
  end
end)

-- load plugin configs
local config_dir = vim.fn.stdpath("config") .. "/lua/plugin/config/"
local fd = vim.loop.fs_scandir(config_dir)
if fd then
  while true do
    local file_name, type = vim.loop.fs_scandir_next(fd)
    if not file_name then
      break
    end
    if type == "file" then
      local plugin_name = file_name:gsub("%.lua$", "")
      local file_path = config_dir .. file_name
      if tb(jp.tap(plugin_name)) or tb(vim.tbl_contains(my_plugin_list, plugin_name)) then
        if tb(vim.tbl_contains(startup_list, plugin_name)) then
          vim.cmd.luafile(file_path)
        elseif tb(vim.tbl_contains(vim_enter_list, plugin_name)) then
          vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
              vim.cmd.luafile(file_path)
            end,
          })
        else
          vim.defer_fn(function()
            vim.cmd.luafile(file_path)
          end, 0)
        end
      end
    end
  end
end

-- check if all plugins are istalled
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, name in ipairs(jp.names()) do
      if not tb(jp.tap(name)) then
        jp.sync()
        pcall(vim.cmd.LuaCacheClear, "")
        vim.cmd.source(os.getenv("MYVIMRC"))
        break
      end
    end
  end,
})
