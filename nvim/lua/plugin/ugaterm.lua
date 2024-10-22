return {
	"uga-rosa/ugaterm.nvim",
	cmd = { "UgatermOpen", "UgatermSend" },
	keys = {
		{ "<c-z>", "<cmd>UgatermOpen -toggle<cr>", mode = { "n", "t" } },
	},
	opts = {
		open_cmd = function()
			local height = vim.api.nvim_get_option("lines")
			local width = vim.api.nvim_get_option("columns")
			local bufnr = vim.api.nvim_open_win(0, true, {
				relative = "editor",
				row = math.floor(height * 0.1),
				col = math.floor(width * 0.1),
				height = math.floor(height * 0.8),
				width = math.floor(width * 0.8),
			})

			-- set winblend to 20
			vim.api.nvim_win_set_option(bufnr, "winblend", 20)
		end,
	},
}
