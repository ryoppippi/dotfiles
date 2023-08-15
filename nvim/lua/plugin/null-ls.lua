return {
	"jose-elias-alvarez/null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	cond = not is_vscode(),
	dependencies = {
		"nvim-lua/plenary.nvim",
		"jay-babu/mason-null-ls.nvim",
	},
	opts = function(_, opts)
		local null_ls = require("null-ls")
		local diagnostics_format = "[#{c}] #{m} (#{s})"
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		local with_root_file = function(...)
			local files = { ... }
			return function(utils)
				return utils.root_has_file(files)
			end
		end

		opts = opts or {}
		opts.sources = vim.tbl_flatten({
			opts.sources or {},
			{
				-- web
				formatting.deno_fmt.with({
					condition = with_root_file("deno.json", "deno.jsonc"),
				}),

				-- python
				diagnostics.vacuum,
				-- diagnostics.cspell,
			},
		})
		return opts
	end,
}
