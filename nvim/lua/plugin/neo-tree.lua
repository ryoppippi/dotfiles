return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v2.x",
	enabled = false,
	event = { "BufAdd", "TabEnter" },
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons",
		"MunifTanjim/nui.nvim",
	},
	cmd = {
		"NeoTreeShowInSplit",
		"NeoTreeFloatToggle",
		"NeoTreeShow",
		"Neotree",
	},
	keys = {
		{ "<leader>E", vim.cmd.NeoTreeShowInSplit, silent = true, desc = "Neotree show in split" },
		{ "<leader>e", vim.cmd.NeoTreeFloatToggle, silent = true, desc = "Neotree float toggle" },
	},
	init = function()
		-- hijack at lazy loading
		-- if tb(vim.fn.isdirectory(vim.fn.expand("%:p"))) then
		--   vim.cmd.cd(vim.fn.expand("%:p:h"))
		--   vim.cmd.bd()
		--   vim.cmd.NeoTreeShowInSplit()
		-- end
	end,
	config = function(_, opts)
		vim.cmd([[
        hi link NeoTreeDirectoryName Directory
        hi link NeoTreeDirectoryIcon NeoTreeDirectoryName
      ]])
		require("neo-tree").setup(opts)
	end,
	opts = function()
		return {
			close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
			popup_border_style = "rounded",
			enable_git_status = true,
			enable_diagnostics = true,
			default_component_configs = {
				indent = {
					indent_size = 2,
					padding = 1, -- extra padding on left hand side
					with_markers = true,
					indent_marker = "│",
					last_indent_marker = "└",
					highlight = "NeoTreeIndentMarker",
				},
				icon = {
					folder_closed = "",
					folder_open = "",
					folder_empty = "ﰊ",
					default = "*",
				},
				name = {
					trailing_slash = false,
					use_git_status_colors = true,
				},
				git_status = {
					-- highlight = "NeoTreeDimText", -- if you remove this the status will be colorful
				},
			},
			event_handlers = {
				{
					event = "file_opened",
					handler = function(_)
						require("neo-tree").close_all()
					end,
				},
			},
			filesystem = {
				filtered_items = {
					--These filters are applied to both browsing and searching
					hide_dotfiles = false,
					hide_gitignored = false,
				},
				follow_current_file = true, -- This will find and focus the file in the active buffer every
				use_libuv_file_watcher = false, -- This will use the OS level file watchers
				hijack_netrw_behavior = "open_current", -- netrw disabled, opening a directory opens neo-tree
				window = {
					position = "left",
					width = 30,
					mappings = {
						["<2-LeftMouse>"] = "open",
						["o"] = "open",
						["<cr>"] = "open",
						["l"] = "open",
						["h"] = "close_node",
						["s"] = "none",
						["S"] = "none",
						["V"] = "open_split",
						["v"] = "open_vsplit",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["H"] = "toggle_hidden",
						["I"] = "toggle_gitignore",
						["R"] = "refresh",
						["/"] = "fuzzy_finder",
						--["/"] = "filter_as_you_type", -- this was the default until v1.28
						-- ["/"] = "none", -- Assigning a key to "none" will remove the default mapping
						["f"] = "filter_on_submit",
						["<c-x>"] = "clear_filter",
						["a"] = "add",
						["d"] = "delete",
						["r"] = "rename",
						["c"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["m"] = "move", -- takes text input for destination
						["q"] = "close_window",
						["<esc>"] = "close_window",
						["t"] = "none",
					},
				},
			},
			buffers = {
				show_unloaded = true,
				window = {
					position = "left",
					mappings = {
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						-- ["S"] = "open_split",
						-- ["s"] = "open_vsplit",
						["<bs>"] = "navigate_up",
						["."] = "set_root",
						["R"] = "refresh",
						["a"] = "add",
						["d"] = "delete",
						["r"] = "rename",
						["c"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["bd"] = "buffer_delete",
					},
				},
			},
			git_status = {
				window = {
					position = "float",
					mappings = {
						["<2-LeftMouse>"] = "open",
						["<cr>"] = "open",
						-- ["S"] = "open_split",
						-- ["s"] = "open_vsplit",
						["C"] = "close_node",
						["R"] = "refresh",
						["d"] = "delete",
						["r"] = "rename",
						["c"] = "copy_to_clipboard",
						["x"] = "cut_to_clipboard",
						["p"] = "paste_from_clipboard",
						["A"] = "git_add_all",
						["gu"] = "git_unstage_file",
						["ga"] = "git_add_file",
						["gr"] = "git_revert_file",
						["gc"] = "git_commit",
						["gp"] = "git_push",
						["gg"] = "git_commit_and_push",
					},
				},
			},
		}
	end,
}
