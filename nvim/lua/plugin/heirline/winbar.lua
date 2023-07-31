local utils = require("heirline.utils")

local FileName = require("plugin.heirline.components.FileName")
local FileIcon = require("plugin.heirline.components.FileIcon")

local Readonly = require("plugin.heirline.components.Readonly")

local WinBar = {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}

WinBar = utils.insert(WinBar, {
	Readonly,
	FileIcon,
	FileName,
})

return WinBar
