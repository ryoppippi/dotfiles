return {
	"stevearc/oil.nvim",
	event = "VeryLazy",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>e",
			function()
				-- curerent directory
				local cd = vim.fn.expand("%:p:h")

				require("oil").open(cd)
			end,
		},
	},
	init = function()
		if tb(vim.fn.isdirectory(vim.fn.expand("%:p"))) then
			require("oil").open(vim.fn.expand("%:p:h"))
		end
	end,
	opts = function()
		local trash_command = "trash"
		local is_trash = tb(vim.fn.executable(trash_command))
		return {
			keymaps = {
				["g?"] = "actions.show_help",
				["<CR>"] = "actions.select",
				["-"] = "actions.parent",
				["<C-p>"] = "actions.preview",
				["q"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["<space>"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
				-- ["<C-s>"] = "actions.select_vsplit",
				-- ["<C-h>"] = "actions.select_split",
				-- ["<C-t>"] = "actions.select_tab",
			},
			view_options = {
				show_hidden = true,
			},
			use_default_keymaps = false,
			delete_to_trash = is_trash,
			trash_command = trash_command,
		}
	end,
	config = function(_, opts)
		require("oil").setup(opts)
	end,
}
