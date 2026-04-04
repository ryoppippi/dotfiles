local M = {}

M.openWithQuickLook = {
	callback = function()
		local oil = require("oil")
		local entry = oil.get_cursor_entry()
		local dir = oil.get_current_dir()
		if not entry or not dir then
			return
		end
		local path = dir .. entry.name

		require("core.utils").open_file_with_quicklook(path)
	end,
	desc = "Open with QuickLook",
}

return M
