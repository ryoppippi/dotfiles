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
		opts.sources = require("core.utils").merge_arrays(opts.sources or {}, {
			-- web
			formatting.prettier.with({
				extra_filetypes = { "svelte" },
			}),

			diagnostics.tsc.with({
				diagnostics_format = diagnostics_format,
				condition = with_root_file("deno.json", "deno.jsonc"),
			}),

			formatting.deno_fmt.with({
				condition = with_root_file("deno.json", "deno.jsonc"),
			}),

			-- python
			formatting.ruff.with({
				diagnostics_format = diagnostics_format,
				prefer_local = ".venv/bin",
				-- extra_args = { "--fast", "-W", "6" },
			}),

			diagnostics.mypy.with({
				diagnostics_format = diagnostics_format,
				prefer_local = ".venv/bin",
			}),

			-- Docker
			diagnostics.hadolint.with({
				diagnostics_format = diagnostics_format,
			}),

			diagnostics.vacuum,
			-- diagnostics.cspell,
		})
		return opts
	end,
}
