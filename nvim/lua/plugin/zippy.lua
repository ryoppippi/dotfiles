return {
	"PatschD/zippy.nvim",
	init = function()
		vim.api.nvim_create_user_command("ZippyInsertPrint", function()
			require("zippy").insert_print()
		end, { nargs = 0 })
	end,
}
