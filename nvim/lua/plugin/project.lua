---@type LazySpec
return {
	"ahmedkhalf/project.nvim",
	event = "VeryLazy",
	enabled = false,
	init = function()
		require("plugin.telescope").le("projects")
	end,
	opts = {
		patterns = {
			-- git
			".git",
			-- shell
			"Makefile",
			-- node
			"package.json",
			"tsconfig.json",
			"node_modules",
			-- deno
			"deno.json",
			"deno.jsonc",
			"import_map.json",
			-- lua
			"stylua.toml",
			".stylua.toml",
			-- go
			"go.mod",
			-- rust
			"Cargo.toml",
			-- python
			"pyproject.toml",
			".venv",
			-- zig
			"build.zig",
		},
	},
	config = function(_, opts)
		require("project_nvim").setup(opts)
	end,
}
