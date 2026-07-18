local has = require("core.plugin").has

---Check if there is a word just before the cursor
---@return boolean
local function has_words_before()
	if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
		return false
	end
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
	"saghen/blink.cmp",
	version = "1.*",
	event = { "InsertEnter", "CmdlineEnter" },
	cond = not is_vscode(),
	dependencies = {
		{ "moyiz/blink-emoji.nvim" },
		{ "ribru17/blink-cmp-spell" },
		{
			"Kaiser-Yang/blink-cmp-git",
			dependencies = { "nvim-lua/plenary.nvim" },
		},
	},
	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "none",
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-l>"] = { "cancel", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<C-k>"] = { "select_prev", "fallback" },
			["<A-j>"] = { "scroll_documentation_down", "fallback" },
			["<A-k>"] = { "scroll_documentation_up", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<Tab>"] = {
				"select_next",
				"snippet_forward",
				function(cmp)
					if has_words_before() then
						return cmp.show()
					end
				end,
				"fallback",
			},
			["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
		},
		completion = {
			list = {
				selection = { preselect = false, auto_insert = false },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
			},
			ghost_text = {
				enabled = false, -- this feature conflicts with the copilot.lua's preview.
			},
			menu = {
				draw = {
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "source_name" },
					},
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if has("nvim-highlight-colors") and ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr ~= "" then
										icon = color_item.abbr
									end
								end
								return icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								local highlight = "BlinkCmpKind" .. ctx.kind
								if has("nvim-highlight-colors") and ctx.item.source_name == "LSP" then
									local color_item = require("nvim-highlight-colors").format(
										ctx.item.documentation,
										{ kind = ctx.kind }
									)
									if color_item and color_item.abbr_hl_group then
										highlight = color_item.abbr_hl_group
									end
								end
								return highlight
							end,
						},
					},
				},
			},
		},
		appearance = {
			kind_icons = {
				Text = "󰉿",
				Method = "󰆧",
				Function = "󰊕",
				Constructor = "",
				Field = "󰜢",
				Variable = "",
				Class = "󰠱",
				Interface = "",
				Module = "",
				Property = "󰜢",
				Unit = "",
				Value = "󰎠",
				Enum = "",
				Keyword = "",
				Snippet = "",
				Color = "󰏘",
				File = "󰈙",
				Reference = "󰈇",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "󰏿",
				Struct = "󰙅",
				Event = "",
				Operator = "󰆕",
				TypeParameter = "",
			},
		},
		sources = {
			default = { "lsp", "path", "snippets", "buffer", "emoji", "spell" },
			per_filetype = {
				gitcommit = { "git", "lsp", "path", "emoji", "buffer", "spell" },
				octo = { "git", "lsp", "path", "emoji", "buffer", "spell" },
				markdown = { "git", "lsp", "path", "emoji", "buffer", "spell" },
			},
			providers = {
				emoji = {
					module = "blink-emoji",
					name = "Emoji",
					score_offset = 15,
					opts = { insert = true },
				},
				spell = {
					module = "blink-cmp-spell",
					name = "Spell",
					score_offset = -10,
				},
				git = {
					module = "blink-cmp-git",
					name = "Git",
					opts = {},
				},
			},
		},
		cmdline = {
			enabled = true,
			keymap = { preset = "cmdline" },
			completion = {
				menu = { auto_show = true },
				list = {
					selection = { preselect = false, auto_insert = false },
				},
			},
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
