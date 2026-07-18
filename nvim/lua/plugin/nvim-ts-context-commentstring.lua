return {
	"JoosepAlviste/nvim-ts-context-commentstring",
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	event = "BufReadPost",
	init = function()
		vim.g.skip_ts_context_commentstring_module = true
	end,
	opts = {
		enable = true,
		enable_autocmd = false,
	},
	config = function(_, opts)
		require("ts_context_commentstring").setup(opts)

		-- Hook into builtin commenting (gc/gcc): resolve 'commentstring' from
		-- the tree-sitter node under the cursor so embedded languages (e.g.
		-- JSX, CSS-in-HTML) get the right comment style
		local get_option = vim.filetype.get_option
		---@diagnostic disable-next-line: duplicate-set-field
		vim.filetype.get_option = function(filetype, option)
			return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
				or get_option(filetype, option)
		end
	end,
}
