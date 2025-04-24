local getColorScheme = function()
	local cs = vim.g.colors_name
	if cs == "kanagawa" then
		local ok, kanagawa = pcall(require, "kanagawa")
		if not ok then
			vim.notify("kanagawa is not installed", vim.log.levels.ERROR)
			return cs
		end

		return ("kanagawa-%s"):format(kanagawa._CURRENT_THEME)
	end
	return cs
end

---@type LazySpec
return {
	enabled = false,
	"ryoppippi-macro-colorscheme",
	virtual = true,
	event = "BufEnter",
	opts = {
		macro_cs = "moonlight",
		check_interval = 200,
	},
	config = function(_, opts)
		local debounce = require("core.utils").debounce
		local prev_cs = nil

		local Popup = require("nui.popup")
		local popup = Popup({
			enter = false,
			focusable = false,
			zindex = 100,
			border = {
				style = "single",
			},
			relative = "cursor",
			size = {
				width = 1,
				height = 1,
			},
			position = {
				row = 1,
				col = 1,
			},
		})

		vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
			pattern = "*",
			callback = function()
				popup:update_layout()
			end,
		})

		local changeColorScheme = debounce(
			vim.schedule_wrap(function()
				local reg = vim.fn.reg_recording()
				-- Show popup
				if reg ~= "" then
					popup:mount()
					vim.api.nvim_buf_set_lines(popup.bufnr, 0, -1, false, { reg })
					local crrent_cs = getColorScheme()
					if crrent_cs ~= opts.macro_cs then
						prev_cs = crrent_cs
						vim.cmd.colorscheme(opts.macro_cs)
					end
				else
					if prev_cs ~= nil then
						popup:unmount()
						vim.cmd.colorscheme(prev_cs)
						prev_cs = nil
					end
				end
			end),
			opts.check_interval
		)

		vim.on_key(changeColorScheme)
	end,
}
