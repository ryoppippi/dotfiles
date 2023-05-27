local devicons = require("nvim-web-devicons")

return {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, _ = devicons.get_icon_color(filename, extension, { default = true })
	end,
	provider = function(self)
		return " " .. (self.icon and (self.icon .. " "))
	end,
}
