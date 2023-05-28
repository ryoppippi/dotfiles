---@param on_attach fun(client, buffer)
local function on_attach(on_attach)
	vim.api.nvim_create_autocmd("LspAttach", {
		callback = function(args)
			local buffer = args.buf
			local client = vim.lsp.get_client_by_id(args.data.client_id)
			on_attach(client, buffer)
		end,
	})
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)

local lazy = require("lazy")

-- load plugins
local lazy_opts = {
	defaults = { lazy = false },
	install = { missing = true },
	checker = { enabled = false },
	concurrency = 64,
	performance = {
		cache = {
			enabled = true,
		},
		rtp = {
			disabled_plugins = {
				"gzip",
				"matchit",
				"matchparen",
				"netrwPlugin",
				"tarPlugin",
				"tohtml",
				"tutor",
				"zipPlugin",
			},
		},
	},
}

lazy.setup({
	{
		"jose-elias-alvarez/null-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"neovim/nvim-lspconfig",
		},
		opts = function(_, opts)
			local null_ls = require("null-ls")
			local formatting = null_ls.builtins.formatting

			local with_root_file = function(...)
				local files = { ... }
				return function(utils)
					return utils.root_has_file(files)
				end
			end

			opts = opts or {}
			opts.sources = {
				-- lua
				formatting.stylua.with({
					condition = with_root_file({ "stylua.toml", ".stylua.toml" }),
				}),
			}
			return opts
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "williamboman/mason.nvim" },
		config = function()
			require("mason")
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = {
					"lua_ls",
					"stylua",
				},
			})
		end,
	},

	{
		"nvim-lspconfig",
		config = function()
			require("lspconfig").lua_ls.setup({
				on_attach = function(client)
					if client and client.resolved_capabilities then
						client.server_capabilities.documentFormattingProvider = false
					end
				end,
				flags = { debounce_text_changes = 150 },
				settings = { Lua = { diagnostics = { globals = { "vim" } } } },
			})
		end,
	},
	{
		"lukas-reineke/lsp-format.nvim",
		opts = { sync = true },
		init = function()
			on_attach(function(client, _)
				local enableFormat = client.server_capabilities.documentFormattingProvider
				if enableFormat then
					require("lsp-format").on_attach(client)
					vim.cmd([[
                cabbrev wq execute "Format sync" <bar> wq
                cabbrev wqa bufdo execute "Format sync" <bar> wa <bar> q
              ]])
				end
			end)
		end,
	},
}, lazy_opts)
