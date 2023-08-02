local le = function(name)
	local load_extension = function()
		require("telescope").load_extension(name)
	end
	return function()
		vim.schedule(load_extension)
	end
end

return {
	"nvim-telescope/telescope.nvim",
	enabled = true,
	cond = not is_vscode(),
	cmd = { "Telescope" },
	dependencies = {
		{ "nvim-lua/plenary.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make", config = le("fzf") },
		{ "nvim-telescope/telescope-live-grep-args.nvim", config = le("live_grep_args") },
		{
			"nvim-telescope/telescope-frecency.nvim",
			dependencies = { "kkharji/sqlite.lua" },
			config = le("frecency"),
		},
		{ "nvim-telescope/telescope-symbols.nvim" },
		{ "nvim-telescope/telescope-github.nvim", config = le("gh") },
		{ "nvim-telescope/telescope-file-browser.nvim", config = le("file_browser") },
		{ "LinArcX/telescope-env.nvim", config = le("env") },
		{ "crispgm/telescope-heading.nvim", config = le("heading") },
		{ "LinArcX/telescope-changes.nvim", config = le("changes") },
		{ "tsakirist/telescope-lazy.nvim", config = le("lazy") },
		{
			"Allianaab2m/telescope-kensaku.nvim",
			dependencies = { "lambdalisue/kensaku.vim" },
			config = le("kensaku"),
		},
		-- { "nvim-telescope/telescope-ghq.nvim", config = le("ghq") },
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
		require("which-key").register({
			[","] = {
				name = "+Telescope",
				-- ["<space>"] = { [[<cmd>Telescope kensaku<cr>]], "live_grep" },
				["<space>"] = { [[<cmd>Telescope live_grep<cr>]], "live_grep" },
				["f"] = {
					[[<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--smart-case,--files<cr>]],
					"Find File",
				},
				["d"] = {
					[[<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>]],
					"current_buffer_fuzzy_find",
				},
				["<cr>"] = { [[<cmd>Telescope<cr>]], "open Telescope" },
				[","] = { [[<cmd>Telescope oldfiles<cr>]], "oldfiles" },
				["e"] = { [[<cmd>Telescope file_browser<cr>]], "file_browser" },
				["s"] = { [[<cmd>Telescope grep_string<cr>]], "grep_string", mode = { "n", "x" } },
				["t"] = { [[<cmd>TodoTelescope<cr>]], "TODO" },
				["r"] = { [[<cmd>Telescope resume<cr>]], "resume" },
				["b"] = { [[<cmd>Telescope buffers<cr>]], "buffers" },
				["h"] = { [[<cmd>Telescope help_tags<cr>]], "help tags" },
				["H"] = { [[<cmd>Telescope heading<cr>]], "heading" },
				["j"] = { [[<cmd>Telescope jumplist<cr>]], "jumplist" },
				["g"] = { [[<cmd>Telescope git_files<cr>]], "git files" },
				["q"] = { [[<cmd>Telescope quickfix<cr>]], "quickfix" },
				["p"] = { [[<cmd>Telescope commands<cr>]], "commands" },
				["m"] = { [[<cmd>Telescope marks<cr>]], "marks" },
				["c"] = { [[<cmd>Telescope colorscheme<cr>]], "colorscheme" },
				["l"] = { [[<cmd>Telescope lazy<cr>]], "Lazy" },
			},
		})
	end,
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local previewers = require("telescope.previewers")
		local themes = require("telescope.themes")

		local new_maker = function(filepath, bufnr, opts)
			opts = opts or {}
			filepath = vim.fn.expand(filepath)
			vim.loop.fs_stat(filepath, function(_, stat)
				if not stat then
					return
				end
				if stat.size > 100000 then
					return
				else
					previewers.buffer_previewer_maker(filepath, bufnr, opts)
				end
			end)
		end

		telescope.setup({
			defaults = themes.get_dropdown({
				mappings = {
					n = {
						["<ESC>"] = actions.close,
						["q"] = actions.close,
						["<C-q>"] = require("telescope.actions").send_to_qflist
							+ require("telescope.actions").open_qflist,
						["<C-s>"] = require("telescope.actions").send_selected_to_qflist
							+ require("telescope.actions").open_qflist,
						["<C-l>"] = require("telescope.actions").send_to_loclist
							+ require("telescope.actions").open_loclist,
					},
					i = {
						["<C-q>"] = require("telescope.actions").send_to_qflist
							+ require("telescope.actions").open_qflist,
						["<C-s>"] = require("telescope.actions").send_selected_to_qflist
							+ require("telescope.actions").open_qflist,
						["<C-l>"] = require("telescope.actions").send_to_loclist
							+ require("telescope.actions").open_loclist,
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
				buffer_previewer_maker = new_maker,
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
					initial_mode = "insert",
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

		for _, v in ipairs({ "notify", "noice" }) do
			local status, _ = pcall(require, v)
			if status then
				telescope.load_extension(v)
			end
		end
	end,
}
