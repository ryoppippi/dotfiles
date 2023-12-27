return {
	"echasnovski/mini.indentscope",
	branch = "stable",
	event = "VeryLazy",
	enabled = false,
	init = function()
		vim.api.nvim_create_autocmd({ "BufEnter" }, {
			callback = function()
				if vim.bo.buftype == "terminal" then
					vim.b.miniindentscope_disable = true
				else
					vim.b.miniindentscope_disable = false
				end
			end,
		})
	end,
	config = function(_, opts)
		require("mini.indentscope").setup(opts)
	end,
}
