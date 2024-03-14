return {
	"stevearc/oil.nvim",
	event = "VeryLazy",
	cmd = { "Oil" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	keys = {
		{
			"<leader>e",
			function()
				vim.cmd.Oil()
			end,
		},
	},
	init = function()
		local path = vim.fn.expand("%:p")
		local oilPathList = { "oil://", "oil%-ssh://", "oil%-trash://" }
		local isDir = vim.fn.isdirectory(path)
		local isOilPath = false

		for _, oilPath in ipairs(oilPathList) do
			if string.match(path, oilPath) ~= nil then
				isOilPath = true
			end
		end

		if isOilPath or isDir then
			require("oil")
		end
	end,
	opts = function()
		local trash_command = "trash"
		local is_trash = tb(vim.fn.executable(trash_command))
		return {
			keymaps = {
				["g?"] = "actions.show_help",
				["<leader>b"] = "actions.open_external",
				["<CR>"] = "actions.select",
				["-"] = "actions.parent",
				["<C-p>"] = "actions.preview",
				["q"] = "actions.close",
				["<C-l>"] = "actions.refresh",
				["<space>"] = "actions.open_cwd",
				["`"] = "actions.cd",
				["~"] = "actions.tcd",
				["g."] = "actions.toggle_hidden",
				["<C-s>"] = "actions.select_vsplit",
				["<C-h>"] = "actions.select_split",
				["<C-t>"] = "actions.select_tab",
			},
			view_options = {
				show_hidden = true,
				is_always_hidden = function(name, _)
					local ignore_list = { ".DS_Store" }
					return vim.tbl_contains(ignore_list, name)
				end,
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
