local plugin_name = "cmp"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	vim.o.completeopt = "menuone,noinsert,noselect"

	local cmp = require(plugin_name)
	local utils = require("utils")
	local t = utils.t
	local toboolean = utils.toboolean
	local vsnip_jumpable = vim.fn["vsnip#jumpable"]

	local setup_opt = {
		snippet = {
			-- REQUIRED - you must specify a snippet engine
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
				-- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
				-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
			end,
		},
		mapping = {
			["<C-l>"] = cmp.mapping({
				i = cmp.mapping.abort(),
				c = cmp.mapping.close(),
			}),
			["<C-j>"] = cmp.mapping.select_next_item(),
			["<C-k>"] = cmp.mapping.select_prev_item(),
			["<C-d>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<CR>"] = function(fallback)
				if cmp.visible() and cmp.get_selected_entry() ~= nil then
					cmp.confirm({ select = false })
				else
					fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
				end
			end,
			-- ['<Space>'] =
			-- function(fallback)
			--   if cmp.visible() then
			--     cmp.abort()
			--   else
			--     fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
			--     end
			--   end,
			["<Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_next_item()
				elseif toboolean(vsnip_jumpable(1)) then
					vim.fn.feedkeys(t("<Plug>(vsnip-jump-next)"), "")
				else
					fallback()
				end
			end, { "i", "s" }),

			["<S-Tab>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					cmp.select_prev_item()
				elseif toboolean(vsnip_jumpable(-1)) then
					vim.fn.feedkeys(t("<Plug>(vsnip-jump-prev)"), "")
				else
					if vim.g.loaded_copilot then
						vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t("<Tab>")), "n", true)
					else
						fallback()
					end
				end
			end, { "i", "s" }),
		},
		sources = cmp.config.sources({
			{ name = "copilot" },
			{ name = "nvim_lsp" },
			{ name = "path" },
			{ name = "buffer" },
			{ name = "rg" },
			{ name = "vsnip" },
			{ name = "git" },
			{ name = "nvim_lsp_document_symbol" },
			{ name = "treesitter" },
			{ name = "nvim_lua" },
			{ name = "calc" },
			{ name = "emoji" },
			{ name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
			{ name = "nvim_lsp_signature_help" },
		}, {
			-- { name = "cmp_tabnine" },
		}),
		completion = {
			completeopt = "menu,menuone,noinsert, noselect",
		},
		experimental = {
			ghost_text = false, -- this feature conflict to the copilot.vim's preview.
		},
	}

	local status_lspkind, lspkind = pcall(require, "lspkind")
	if status_lspkind then
		setup_opt.formatting = {
			format = lspkind.cmp_format({
				mode = "symbol",
				maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
				menu = {
					nvim_lsp = "[LSP]",
					buffer = "[Buffer]",
					nvim_lua = "[Lua]",
					ultisnips = "[UltiSnips]",
					vsnip = "[vSnip]",
					treesitter = "[treesitter]",
					look = "[Look]",
					path = "[Path]",
					spell = "[Spell]",
					calc = "[Calc]",
					emoji = "[Emoji]",
					neorg = "[Neorg]",
					rg = "[rg]",
					cmp_tabnine = "[Tabnine]",
					nvim_lsp_signature_help = "[Signature]",
					copilot = "[Copilot]",
					-- cmp_openai_codex = "[Codex]",
				},
			}),
		}
	end

	cmp.setup(setup_opt)

	cmp.setup.cmdline("/", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
		completion = {
			completeopt = "menu,menuone,noselect",
		},
	})

	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
		completion = {
			completeopt = "menu,menuone,noselect",
		},
	})

	vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])

	-- Setup lspconfig.
	local status_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
	if status_lsp then
		local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
	end

	-- Setup tabnine
	local status_tn, _ = require("utils.plugin").force_require("cmp-tabnine")
	if status_tn then
		require("cmp_tabnine.config"):setup({
			max_lines = 1000,
			max_num_results = 5,
			sort = true,
			run_on_every_keystroke = true,
			snippet_placeholder = "..",
		})
	end

	-- Setup autopairs
	local status_autopairs, _ = require("utils.plugin").force_require("nvim-autopairs")
	if status_autopairs then
		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
		cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
	end

	local status_git, cmp_git = require("utils.plugin").force_require("cmp_git")
	if status_git then
		cmp_git.setup()
	end
end

vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		loading()
	end,
})
