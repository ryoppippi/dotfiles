---@type LazySpec
return {
	dir = "",
	name = "ryoppippi-macro-edit",
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

			--- @type string | nil
			local replaced_reg_content = nil
			vim.ui.input({
				prompt = "Edit a macro",
				default = reg_content,
			}, function(i)
				replaced_reg_content = i
			end)

			if replaced_reg_content == nil then
				vim.notify(string.format("Edit a macro '%s' canceled", reg))
				return
			end

			vim.fn.setreg(reg, replaced_reg_content)
		end)
	end,
}
