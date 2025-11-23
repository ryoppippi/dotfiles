local on_load = require("core.plugin").on_load

---@param name string
local le = function(name)
	on_load("telescope.nvim", function()
		require("telescope").load_extension(name)
	end)
end

---@type LazySpec[]
return {
	{
		"telescope-keymap",
		virtual = true,
		event = "VeryLazy",
		keys = {
			{ "tel", "Telescope", mode = "ca" },
			{ ",,", "<cmd>Telescope smart_open<cr>" },
		},
		config = function()
			local function telescope_grep_any()
				local builtin = require("telescope.builtin")
				local telescope_any = require("telescope-any")
				local extensions = require("telescope").extensions
				local grep_telescope_any = telescope_any.create_telescope_any({
					pickers = {
						["k "] = { extensions.kensaku.kensaku, "Kensaku" },
						[""] = extensions.egrepify.egrepify,
					},
				})
				grep_telescope_any()
			end
		end,
	},
	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		cond = not is_vscode(),
		cmd = { "Telescope" },
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", config = le("fzf") },
			{ "nvim-telescope/telescope-live-grep-args.nvim", config = le("live_grep_args") },
			{ "nvim-telescope/telescope-symbols.nvim" },
			{ "nvim-telescope/telescope-github.nvim", config = le("gh") },
			{ "LinArcX/telescope-env.nvim", config = le("env") },
			{ "crispgm/telescope-heading.nvim", config = le("heading") },
			{ "LinArcX/telescope-changes.nvim", config = le("changes") },
			{ "tsakirist/telescope-lazy.nvim", config = le("lazy") },
			{ "jvgrootveld/telescope-zoxide", config = le("zoxide") },
			{
				"Allianaab2m/telescope-kensaku.nvim",
				dependencies = { "lambdalisue/vim-kensaku" },
				config = le("kensaku"),
			},
			{ "fdschmidt93/telescope-egrepify.nvim", config = le("egrepify") },
			{
				"danielfalk/smart-open.nvim",
				dependencies = {
					{
						"kkharji/sqlite.lua",
						config = function()
							-- Use Nix-provided sqlite library instead of building from source
							-- Detect shared library extension based on platform
							local uname = vim.loop.os_uname()
							local ext = uname.sysname == "Darwin" and ".dylib" or ".so"

							-- Find sqlite3 binary path and derive library path from it
							local sqlite_bin = vim.fn.exepath("sqlite3")
							if sqlite_bin ~= "" then
								-- Resolve symlinks to get actual Nix store path
								local handle = io.popen("readlink -f " .. vim.fn.shellescape(sqlite_bin))
								if handle then
									local resolved = handle:read("*l")
									handle:close()

									if resolved then
										-- Extract Nix store path (e.g., /nix/store/xxx-sqlite-3.50.4-bin)
										-- and look for the lib output in the same closure
										local store_path = resolved:match("(/nix/store/[^/]+)")
										if store_path then
											-- Try to find libsqlite3 in sibling outputs
											local parent = store_path:match("(.+)/[^/]+")
											if parent then
												local handle2 = io.popen(
													"find "
														.. vim.fn.shellescape(parent)
														.. " -name 'libsqlite3"
														.. ext
														.. "' -type f 2>/dev/null | head -1"
												)
												if handle2 then
													local lib_path = handle2:read("*l")
													handle2:close()
													if lib_path and lib_path ~= "" then
														vim.g.sqlite_clib_path = lib_path
													end
												end
											end
										end
									end
								end
							end

							-- Fallback: let the system find it
							if not vim.g.sqlite_clib_path then
								vim.g.sqlite_clib_path = "libsqlite3" .. ext
							end
						end,
					},
					{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
					"nvim-telescope/telescope-fzy-native.nvim",
				},
				config = le("smart_open"),
			},
			{ "d00h/telescope-any" },
			{ "nvim-telescope/telescope-ghq.nvim", config = le("ghq") },
			-- {
			-- 	"nvim-telescope/telescope-frecency.nvim",
			-- 	config = le("frecency"),
			-- },
			-- {
			-- 	"nvim-telescope/telescope-media-files.nvim",
			-- 	dependencies = {
			-- 		"nvim-lua/plenary.nvim",
			-- 		"nvim-lua/popup.nvim",
			-- 	},
			-- 	config = le("media_files"),
			-- },
		},
		init = function()
			vim.api.nvim_create_autocmd("BufReadPost", {
				pattern = "*",
				callback = function()
					vim.cmd.stopinsert()
				end,
			})
		end,
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local previewers = require("telescope.previewers")
			local themes = require("telescope.themes")

			---@param filepath string: path to the file to preview
			---@param bufnr number: buffer number to load the file into
			---@param opts table: options table
			---@return nil
			local new_maker = function(filepath, bufnr, opts)
				opts = opts or {}

				local expand_filepath = vim.fn.expand(filepath)

				local async = require("plenary.async")

				async.void(function()
					local err, stat = async.uv.fs_stat(expand_filepath)
					assert(not err, err)

					if not stat then
						return
					end
					if stat.size > 100000 then
						return
					else
						return previewers.buffer_previewer_maker(filepath, bufnr, opts)
					end
				end)
			end

			telescope.setup({
				defaults = themes.get_dropdown({
					path_display = {
						filename_first = {
							reverse_directories = true,
						},
					},
					mappings = {
						n = {
							["<ESC>"] = actions.close,
							["q"] = actions.close,
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.send_to_loclist + actions.open_loclist,
						},
						i = {
							["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
							["<C-s>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-l>"] = actions.send_to_loclist + actions.open_loclist,
							["<CR>"] = function(prompt_bufnr)
								require("telescope.actions").select_default(prompt_bufnr)
								vim.cmd.stopinsert()
							end,
						},
					},
					initial_mode = "insert",
					prompt_prefix = "🔍",
					-- cache_picker = {
					-- 	num_pickers = -1,
					-- },
					vimgrep_arguments = {
						"rg",
						-- "ug",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
					},
					file_ignore_patterns = {
						".git/",
					},
					color_devicons = true,
					use_less = true,
					scroll_strategy = "cycle",
					set_env = { ["COLORTERM"] = "truecolor" },
					-- buffer_previewer_maker = new_maker,
					winblend = 20,
					layout_strategy = "flex",
					layout_config = {
						width = 0.8,
						height = 0.8,
						horizontal = {
							mirror = false,
							prompt_position = "top",
							preview_width = 0.5,
						},
						vertical = {
							mirror = false,
							prompt_position = "top",
							preview_height = 0.3,
						},
					},
				}),
				pickers = {
					diagnostics = {
						initial_mode = "normal",
					},
					grep_string = {
						initial_mode = "normal",
					},
					oldfiles = {
						-- initial_mode = "normal",
					},
					colorscheme = {
						enable_preview = true,
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						-- case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
					file_browser = {
						initial_mode = "normal",
					},
					heading = {
						theme = "dropdown",
						initial_mode = "normal",
						treesitter = true,
					},
					frecency = {
						initial_mode = "normal",
						show_scores = true,
					},
					lazy = {
						mappings = {
							open_in_browser = "<C-o>",
							open_in_find_files = "<C-f>",
							open_in_live_grep = "<C-g>",
							open_plugins_picker = "<C-b>",
						},
					},
				},
			})
		end,
	},
	-- {
	-- 	"prochri/telescope-all-recent.nvim",
	-- 	dependencies = {
	-- 		"kkharji/sqlite.lua",
	-- 		"nvim-telescope/telescope.nvim",
	-- 	},
	-- 	init = function()
	-- 		on_load("telescope.nvim", function()
	-- 			require("telescope-all-recent").setup({})
	-- 		end)
	-- 	end,
	-- },
	le = le,
}
