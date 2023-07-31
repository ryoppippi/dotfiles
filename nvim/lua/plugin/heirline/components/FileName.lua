local conditions = require("heirline.conditions")

return {
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
	hl = function()
		local opt = { bold = true }
		if vim.bo.modified then
			-- use `force` because we need to override the child's hl foreground
			opt.fg = "cyan"
			opt.force = true
		end
		return opt
	end,
	provider = function(self)
		local filename = vim.fn.fnamemodify(self.filename, ":.")
		if filename == "" then
			filename = "[No Name]"
		end
		if not conditions.width_percent_below(#filename, 1) then
			local split_path = vim.split(filename, "/")
			local last = split_path[#split_path]
			local rest = table.concat(vim.list_slice(split_path, 1, #split_path - 1), "/")
			local shorten = vim.fn.pathshorten(rest)
			filename = shorten .. "/" .. last
		end
		return filename
	end,
}
