return {
	"stevearc/oil.nvim",
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
		local openWithOil = function()
			local path = vim.fn.expand("%:p")

			---@cast path string
			if string.match(path, "oil://") then
				return
			end

			if not tb(vim.fn.isdirectory(path)) then
				return
			end

			vim.cmd.Oil(path)
		end
		vim.api.nvim_create_autocmd({ "BufEnter" }, { callback = openWithOil, nested = true })
		vim.api.nvim_create_autocmd({ "VimEnter" }, { callback = openWithOil })
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
