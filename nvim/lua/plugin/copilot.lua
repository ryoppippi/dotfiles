local event = { "InsertEnter", "VeryLazy" }

return {
	"zbirenbaum/copilot.lua",
	enabled = true,
	cond = not is_vscode(),
	cmd = { "Copilot" },
	event = event,
	opts = {
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
				prev = "<C-m>",
				dismiss = "<C-l>",
			},
		},
		filetypes = {
			TeleScopePrompt = false,
			["*"] = true,
		},
	},
	config = function(_, opts)
		local cmp = require("cmp")

		cmp.event:on("menu_opened", function()
			vim.b.copilot_suggestion_hidden = true
		end)

		cmp.event:on("menu_closed", function()
			vim.b.copilot_suggestion_hidden = false
		end)
		vim.defer_fn(function()
			require("copilot").setup(opts)
		end, 100)
	end,
}
