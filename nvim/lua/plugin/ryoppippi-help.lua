return {
	"ryoppippi-help.nvim",
	virtual =true,
	dependencies = { "MunifTanjim/nui.nvim" },
	cmd = { "H" },
	config = function()
		vim.api.nvim_create_user_command("H", function(tbl)
			local args = tbl.args
			local Popup = require("nui.popup")
			if not Popup then
				vim.cmd.tabnew()
				vim.bo.buftype = "help"
				vim.cmd.help(args)
				return
			end
			local popup = Popup({
				enter = true,
				focusable = true,
				border = {
					style = "rounded",
				},
				relative = "editor",
				position = "50%",
				size = {
					width = "80%",
					height = "80%",
				},
				buf_options = {
					modifiable = false,
					readonly = true,
					buftype = "help",
				},
			})
			local unmount = function()
				popup:unmount()
			end

			popup:mount()
			vim.cmd.help(args)
			popup:on("BufLeave", function()
				popup:unmount()
			end)
			for _, v in ipairs({ "<esc>", "q" }) do
				popup:map("n", v, unmount, { noremap = true })
			end
		end, { nargs = "?", complete = "help", force = true })
	end,
}
