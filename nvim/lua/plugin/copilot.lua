local event = { "InsertEnter", "VeryLazy" }

-- Nix puts the server on the wrapper's PATH; without it copilot.lua downloads one
local server_path = vim.fn.exepath("copilot-language-server")

return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cond = not is_vscode(),
	cmd = { "Copilot" },
	event = event,
	opts = {
		server = {
			type = "binary",
			custom_server_filepath = server_path ~= "" and server_path or nil,
		},
		panel = {
			auto_refresh = true,
			layout = {
				position = "right",
			},
			keymap = {
				jump_prev = "_",
				jump_next = "-",
				accept = "<CR>",
				refresh = false,
				open = "<C-S-CR>",
			},
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			keymap = {
				accept = "<C-s>",
				accept_word = false,
				accept_line = false,
				next = "<C-n>",
				prev = false,
				dismiss = "<C-l>",
			},
		},
		filetypes = {
			TeleScopePrompt = false,
			["*"] = true,
		},
		should_attach = function(bufnr, bufname)
			if vim.g.copilot_disable_project then
				return false
			end
			return require("copilot.config.should_attach").default(bufnr, bufname)
		end,
	},
	config = function(_, opts)
		vim.defer_fn(function()
			require("copilot").setup(opts)
		end, 100)
	end,
}
