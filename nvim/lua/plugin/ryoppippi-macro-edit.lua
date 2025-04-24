---@type LazySpec
return {
	"ryoppippi-macro-edit",
	virtual = true,
	keys = {
		{ "<leader>q", "<Plug>(macro_edit)", desc = "Edit a macro", silent = true },
	},
	config = function()
		vim.keymap.set("n", "<Plug>(macro_edit)", function()
			local reg = string.char(vim.fn.getchar())

			local reg_content = vim.fn.getreg(reg)

			if reg_content == "" then
				vim.notify(string.format("Macro '%s' is empty", reg))
				return
			end

			vim.ui.input({
				prompt = "Edit a macro",
				default = reg_content,
			}, function(i)
				if i == nil or i == "" then
					vim.notify(string.format("Edit a macro '%s' canceled", reg))
					return
				end
				vim.fn.setreg(reg, i)
			end)
		end)
	end,
}
