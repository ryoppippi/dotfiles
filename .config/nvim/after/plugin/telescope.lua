local plugin_name = "telescope"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	local telescope = require(plugin_name)
	local actions = require(plugin_name .. ".actions")

	telescope.setup({
		defaults = {
			mappings = {
				n = {
					["<ESC>"] = actions.close,
					["q"] = actions.close,
				},
			},
			initial_mode = "insert",
			prompt_prefix = "🔍",
			-- cache_picker = {
			-- 	num_pickers = -1,
			-- },
			vimgrep_arguments = {
				"rg",
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
				".cache",
				"%.o",
				"%.a",
				"%.out",
				"%.class",
				"%.pdf",
				"%.mkv",
				"%.mp4",
				"%.zip",
			},
		},
		pickers = {
			diagnostics = {
				theme = "dropdown",
				initial_mode = "normal",
			},
			grep_string = {
				initial_mode = "normal",
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
		},
	})
	telescope.load_extension("fzf")
	telescope.load_extension("file_browser")
end

local function keymap()
	local key_opts = { noremap = true, silent = true }
	vim.api.nvim_set_keymap("n", ",", "[TeLeader]", {})
	vim.keymap.set("n", "[TeLeader]", "<Nop>", { noremap = true, silent = true })
	vim.api.nvim_set_keymap("n", "[TeLeader]<cr>", "<cmd>WhichKey [TeLeader]<cr>", { noremap = true })

	local find_files_cmd = [[<cmd>Telescope find_files find_command=rg,--ignore,--hidden,--smart-case,--files<cr>]]
	local current_buffer_fuzzy_find = [[<cmd>Telescope current_buffer_fuzzy_find fuzzy=false case_mode=ignore_case<cr>]]

	vim.keymap.set("n", "[TeLeader]f", find_files_cmd, key_opts)
	vim.keymap.set("n", "[TeLeader]<space>", [[<cmd>Telescope live_grep<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader],", [[<cmd>Telescope<cr>]], { noremap = true })
	vim.keymap.set("n", "[TeLeader]z", [[<cmd>Telescope file_browser<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]s", [[<cmd>Telescope grep_string<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]t", [[<cmd>TodoTelescope<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]r", [[<cmd>Telescope resume<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]b", [[<cmd>Telescope buffers<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]h", [[<cmd>Telescope help_tags<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]j", [[<cmd>Telescope jumplist<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]o", [[<cmd>Telescope oldfiles<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]g", [[<cmd>Telescope git_files<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]q", [[<cmd>Telescope quickfix<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]p", [[<cmd>Telescope pickers<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]m", [[<cmd>Telescope marks<cr>]], key_opts)
	vim.keymap.set("n", "[TeLeader]d", current_buffer_fuzzy_find, key_opts)

	vim.keymap.set("n", "gd", [[<cmd>Telescope lsp_definitions<cr>]], key_opts)
	vim.keymap.set("n", "gJ", [[<cmd>Telescope diagnostics<cr>]], key_opts)
	vim.keymap.set("n", "gt", [[<cmd>Telescope lsp_type_definitions<cr>]], key_opts)
	vim.keymap.set("n", "gI", [[<cmd>Telescope lsp_implementations<cr>]], key_opts)
	vim.keymap.set("n", "gr", [[<cmd>Telescope lsp_references<cr>]], key_opts)
	vim.keymap.set("n", "<leader>ca", [[<cmd>Telescope lsp_code_actions<cr>]], key_opts)
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
require("utils.plugin").force_load_on_event(plugin_name, keymap)
