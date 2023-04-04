local Navic = require("plugin.config.heirline.components.Navic")
local FileName = require("plugin.config.heirline.components.FileName")
local FileIcon = require("plugin.config.heirline.components.FileIcon")
local FileInfo = require("plugin.config.heirline.components.FileInfo")

local Readonly = require("plugin.config.heirline.components.Readonly")

return {
  Readonly,
  FileInfo,
  FileIcon,
  FileName,
  { provider = " > ", condition = vim.b.navic_client_id ~= nil },
  Navic,
}

