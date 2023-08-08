local has_cmp = function()
	return require("core.plugin").has("nvim-cmp")
end

local event = { "InsertEnter" }

return {
	{
		"github/copilot.vim",
		enabled = true,
		cond = not is_vscode(),
		dependencies = {
			"tani/vim-artemis",
			{
				"hrsh7th/cmp-copilot",
				cond = has_cmp,
			},
		},
		cmd = { "Copilot" },
		event = event,
		keys = function()
			return {
				{
					"<Plug>(copilot-dummy-map)",
					function()
						vimx.fn.copilot.Accept("<Tab>")
					end,
					mode = "i",
					expr = true,
					desc = "copilot accept",
				},
				{
					"<C-h>",
					function()
						vimx.fn.copilot.Accept("<CR>")
					end,
					mode = "i",
					expr = true,
					desc = "copilot accept",
				},
				{
					"<C-l>",
					function()
						vimx.fn.copilot.Dismiss()
					end,
					mode = "i",
					script = true,
					nowait = true,
					expr = true,
					desc = "copilot dismiss",
				},
				{
					"<c-cr>",
					function()
						vimx.fn.copilot.Suggest()
					end,
					mode = "i",
					expr = true,
					desc = "copilot suggest",
				},
				{
					"<C-n>",
					function()
						vimx.fn.copilot.Next()
					end,
					mode = "i",
					script = true,
					nowait = true,
					expr = true,
					desc = "copilot next",
				},
				{
					"<C-m>",
					function()
						vimx.fn.copilot.Previous()
					end,
					mode = "i",
					script = true,
					nowait = true,
					expr = true,
					desc = "copilot previous",
				},
			}
		end,
		init = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_no_maps = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
			vim.g.copilot_filetypes = { ["*"] = true }
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		cond = not is_vscode(),
		cmd = { "Copilot" },
		event = event,
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				cond = has_cmp,
				dependencies = {
					"hrsh7th/nvim-cmp",
				},
				config = function()
					require("copilot_cmp").setup()

					local cmp = require("cmp")

					cmp.event:on("menu_opened", function()
						vim.b.copilot_suggestion_hidden = true
					end)

					cmp.event:on("menu_closed", function()
						vim.b.copilot_suggestion_hidden = false
					end)
				end,
			},
		},
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
					accept = "<Tab>",
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
			vim.defer_fn(function()
				require("copilot").setup(opts)
			end, 100)
		end,
	},
}
