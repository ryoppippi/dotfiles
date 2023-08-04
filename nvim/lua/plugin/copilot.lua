local has_cmp = function()
	return require("core.plugin").has("nvim-cmp")
end

local event = { "InsertEnter" }

return {
	{
		"github/copilot.vim",
		enabled = false,
		cond = not is_vscode(),
		dependencies = {
			"tani/vim-artemis",
			{
				-- "ryoppippi/cmp-copilot",
				-- branch = "dev/add-copilot-loaded-detecter",
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
			}
		end,
		init = function()
			vim.g.copilot_no_tab_map = true
			vim.g.copilot_assume_mapped = true
			vim.g.copilot_tab_fallback = ""
			vim.g.copilot_filetypes = { ["*"] = true }
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		enabled = true,
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

					vim.keymap.set("i", "<C-CR>", function()
						cmp.mapping.abort()
						require("copilot.suggestion").accept()
					end, {
						desc = "[copilot] accept suggestion",
						silent = true,
					})
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
					refresh = "gr",
					open = "<C-CR>",
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
			vim.api.nvim_command("highlight link CopilotAnnotation LineNr")
			vim.api.nvim_command("highlight link CopilotSuggestion LineNr")

			vim.defer_fn(function()
				require("copilot").setup(opts)
			end, 100)
		end,
	},
}
