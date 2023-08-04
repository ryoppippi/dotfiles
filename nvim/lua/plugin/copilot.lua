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
		dependencies = {
			{
				"zbirenbaum/copilot-cmp",
				cond = has_cmp,
				config = true,
			},
		},
		event = event,
		config = function()
			vim.defer_fn(function()
				require("copilot").setup({
					suggestion = {
						enabled = true,
						auto_trigger = true,
						keymap = {
							accept = "<Tab>",
							accept_word = false,
							accept_line = false,
							-- next = "<C-S-n>",
							-- prev = "<C-S-p>",
							dismiss = "<C-l>",
						},
					},
				})
			end, 100)
		end,
	},
}
