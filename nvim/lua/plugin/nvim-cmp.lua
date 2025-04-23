local has = require("core.plugin").has

local enabled_copilot_vim = function()
	return has("copilot.vim") and tb(vim.g.loaded_copilot)
end

local feedkey = function(key, mode)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local function load_after(plugin)
	local dir = plugin.dir .. "/after/plugin"
	local fd = vim.loop.fs_scandir(dir)
	if not fd then
		return
	end
	while true do
		local file_name, type = vim.loop.fs_scandir_next(fd)
		if not file_name then
			break
		end
		if type == "file" then
			vim.cmd.source(dir .. "/" .. file_name)
		end
	end
end

return {
	"https://github.com/iguanacucumber/magazine.nvim",
	name = "nvim-cmp",
	event = { "InsertEnter", "CmdlineEnter" },
	cond = not is_vscode(),
	dependencies = {
		{ "tani/vim-artemis" },
		{ "onsails/lspkind.nvim" },
		{
			"hrsh7th/cmp-buffer",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"https://codeberg.org/FelipeLema/cmp-async-path",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"hrsh7th/cmp-cmdline",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"hrsh7th/cmp-calc",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"hrsh7th/cmp-emoji",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"lukas-reineke/cmp-rg",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"lukas-reineke/cmp-under-comparator",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"f3fora/cmp-spell",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"petertriho/cmp-git",
			dependencies = { "nvim-lua/plenary.nvim" },
			opts = {
				filetypes = { "gitcommit", "octo" },
			},
			config = true,
		},
		{
			"hrsh7th/cmp-nvim-lsp",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"hrsh7th/cmp-nvim-lsp-document-symbol",
			config = function(p)
				load_after(p)
			end,
		},
		{
			"hrsh7th/cmp-nvim-lsp-signature-help",
			enabled = false,
			config = function(p)
				load_after(p)
			end,
		},
		{ "ray-x/cmp-treesitter" },
	},
	init = function()
		require("core.plugin").on_load("nvim-cmp", function()
			vim.api.nvim_exec_autocmds("User", { pattern = "CmpLoaded" })
		end)
	end,
	config = function()
		vim.o.completeopt = "menuone,noinsert,noselect"

		-- Setup dependencies
		local cmp = require("cmp")

		local luasnip_status, luasnip = pcall(require, "luasnip")
		local denippet = vimx.fn.denippet

		local has_words_before = function()
			if vim.api.nvim_get_option_value("buftype", { buf = 0 }) == "prompt" then
				return false
			end
			local line, col = unpack(vim.api.nvim_win_get_cursor(0))
			return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		end

		local snippet_jumpable = function(dir)
			if luasnip_status then
				return tb(luasnip.jumpable(dir))
			elseif denippet ~= nil then
				return tb(denippet.jumpable(dir))
			end
			return false
		end

		local snippet_jump = function(dir)
			if luasnip_status then
				luasnip.jump(dir)
			elseif denippet ~= nil then
				denippet.jump(dir)
			end
		end

		local setup_opt = {
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					if luasnip_status then
						luasnip.lsp_expand(args.body)
					elseif denippet ~= nil then
						if args.body ~= "" then
							denippet.anonymous(args.body)
						end
					end
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-l>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				["<C-y>"] = cmp.config.disable,
				["<C-j>"] = cmp.mapping(function(fallback)
					if denippet ~= nil and tb(denippet.choosable()) then
						feedkey("<Plug>(denippet-choice-next)", "i")
					elseif cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					else
						fallback()
					end
				end),
				["<C-k>"] = cmp.mapping(function(fallback)
					if denippet ~= nil and tb(denippet.choosable()) then
						feedkey("<Plug>(denippet-choice-prev)", "i")
					elseif cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end),

				["<A-j>"] = cmp.mapping.scroll_docs(4),
				["<A-k>"] = cmp.mapping.scroll_docs(-4),
				["<c-n>"] = cmp.mapping(function(fallback)
					fallback()
				end, { "i", "s" }),
				["<CR>"] = cmp.mapping(function(fallback)
					local entry = cmp.get_selected_entry()
					if cmp.visible() and entry ~= nil then
						local confirm_option = {
							select = false,
							-- behavior = entry.source.name == "copilot" and cmp.ConfirmBehavior.Insert
							-- 	or cmp.ConfirmBehavior.Replace,
						}
						cmp.confirm(confirm_option)
					else
						fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
					end
				end, { "i", "s" }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
					elseif snippet_jumpable(1) then
						snippet_jump(1)
					elseif has_words_before() then
						cmp.complete()
					elseif enabled_copilot_vim() then
						-- vim.api.nvim_feedkeys(vimx.fn.copilot.Accept(t("<Tab>")), "n", true)
						feedkey(vimx.fn.copilot.Accept(t("<Tab>")), "n")
					else
						fallback()
					end
				end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() and has_words_before() then
						cmp.select_prev_item()
					elseif snippet_jumpable(-1) then
						snippet_jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sorting = {
				comparators = {
					cmp.config.compare.offset,
					cmp.config.compare.exact,
					cmp.config.compare.score,
					-- cmp.config.compare.scopes,
					require("cmp-under-comparator").under,
					cmp.config.compare.kind,
					cmp.config.compare.recently_used,
					cmp.config.compare.locality,
					cmp.config.compare.sort_text,
					cmp.config.compare.length,
					cmp.config.compare.order,
				},
			},
			sources = cmp.config.sources({
				{ name = "copilot", priority = 90 },
				-- { name = "rg" },
				{ name = "luasnip", priority = 20 },
				{ name = "denippet", priority = 20 },
				{ name = "nvim_lsp", priority = 100, trigger_characters = { "-", ".", "/", ":" } },
				{ name = "async_path", priority = 100 },
				{ name = "emoji", insert = true, priority = 50 },
				{ name = "nvim_lua", priority = 50 },
			}, {
				{ name = "buffer" },
				{ name = "omni" },
				{ name = "calc" },
				{ name = "spell" },
				{ name = "treesitter" },
				{ name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
				-- { name = "cmp_tabnine" },
			}),
			completion = {
				completeopt = "menu,menuone,noinsert,noselect",
			},
			experimental = {
				ghost_text = false, -- this feature conflict to the copilot.vim's preview.
			},
		}

		local menu = {
			nvim_lsp = "[LSP]",
			buffer = "[Buffer]",
			async_path = "[Path]",
			nvim_lua = "[Lua]",
			ultisnips = "[UltiSnips]",
			luasnip = "[LuaSnip]",
			treesitter = "[TS]",
			spell = "[Spell]",
			calc = "[Calc]",
			emoji = "[Emoji]",
			neorg = "[Neorg]",
			rg = "[rg]",
			omni = "[Omni]",
			-- cmp_tabnine = "[Tabnine]",
			copilot = "[Copilot]",
			cmdline_history = "[History]",
			look = "[Look]",
			git = "[Git]",
			ghq = "[GHQ]",
			-- cmp_openai_codex = "[Codex]",
		}

		setup_opt.formatting = {
			format = function(entry, item)
				local color_item = nil
				if has("nvim-highlight-colors") then
					color_item = require("nvim-highlight-colors").format(entry, { kind = item.kind })
				end
				item = require("lspkind").cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					before = function(_entry, vim_item)
						if entry.source.name == "nvim_lsp" then
							vim_item.menu = "{" .. _entry.source.source.client.name .. "}"
						else
							vim_item.menu = menu[_entry.source.name] or _entry.source.name
						end
						return vim_item
					end,
				})(entry, item)
				if color_item ~= nil and color_item.abbr_hl_group then
					item.kind_hl_group = color_item.abbr_hl_group
					item.kind = color_item.abbr
				end
				return item
			end,
		}

		cmp.setup(setup_opt)

		cmp.setup.filetype({ "gitcommit", "octo", "markdown" }, {
			sources = cmp.config.sources({
				{ name = "git" },
				{ name = "ghq" },
				{ name = "copilot" },
				-- { name = "rg" },
				{ name = "luasnip" },
				{ name = "nvim_lsp" },
				{ name = "async_path" },
				{ name = "emoji", insert = true },
				{ name = "codecompanion" },
			}, {
				{ name = "buffer" },
				{ name = "omni" },
				{ name = "spell" },
				{ name = "calc" },
				{ name = "treesitter" },
				{ name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
			}),
		})

		cmp.setup.cmdline("/", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = "nvim_lsp_document_symbol" },
				{ name = "cmdline" },
				{ name = "ghq" },
			}, {
				{ name = "buffer" },
			}),
			completion = {
				completeopt = "menu,menuone,noselect",
			},
		})

		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources(
				{ { name = "async_path" } },
				{ { name = "cmdline" }, { { name = "cmdline_history" } } }
			),
			completion = {
				completeopt = "menu,menuone,noselect",
			},
		})

		vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])
	end,
}
