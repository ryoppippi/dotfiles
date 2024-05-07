---@type LazySpec
return {
	"stevearc/oil.nvim",
	event = "VeryLazy",
	cmd = { "Oil" },
	dependencies = {
		"nvim-tree/nvim-web-devicons",
		"refractalize/oil-git-status.nvim",
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
		local oilPathPatterns = { "oil://", "oil-ssh://", "oil-trash://" }
		local path = vim.fn.expand("%:p")

		-- stylua: ignore start
		local isDir = tb(vim.fn.isdirectory(path))
		local isOilPath = vim.iter(oilPathPatterns):any(function(opp)
			return (string.find(path, opp, 1, true)) ~= nil
		end)
		if isDir or isOilPath then require("oil") end
		-- stylua: ignore end
	end,
	opts = function()
		local trash_command = "trash"
		local is_trash = tb(vim.fn.executable(trash_command))
		local custom_actions = require("plugin.oil.actions")
		return {
			keymaps = {
				["?"] = "actions.show_help",
				["gx"] = "actions.open_external",
				["<CR>"] = "actions.select",
				["-"] = "actions.parent",
				["<C-p>"] = "actions.preview",
				["gp"] = custom_actions.weztermPreview,
				["g<leader>"] = custom_actions.openWithQuickLook,
				["<esc>"] = "actions.close",
				["q"] = nil,
				["<C-l>"] = "actions.refresh",
				["_"] = "actions.open_cwd",
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
			win_options = {
				signcolumn = "yes:2",
			},
		}
	end,
	config = function(_, opts)
		require("oil").setup(opts)
		require("oil-git-status").setup()
	end,
}
