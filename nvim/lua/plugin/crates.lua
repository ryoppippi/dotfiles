return {
	"saecki/crates.nvim",
	event = { "BufRead Cargo.toml" },
	requires = {
		"nvim-lua/plenary.nvim",
		"neovim/nvim-lspconfig",
	},
	init = function()
		require("core.plugin").on_attach(function(client, bufnr)
			local opts = function(desc)
				return { silent = true, buffer = bufnr, desc = desc }
			end
			if client.name == "crates.nvim" then
				local crates = require("crates")
				vim.keymap.set("n", "gd", crates.show_dependencies_popup, opts("Show Crate dependencies popup"))
				vim.keymap.set("n", "gl", crates.show_features_popup, opts("Show Crate features popup"))
				vim.keymap.set("n", "gk", crates.open_documentation, opts("Open Crate documentation"))
				vim.keymap.set("n", "gK", crates.open_crates_io, opts("Open Crate on crates.io"))
				vim.keymap.set("n", "gL", crates.open_repository, opts("Open Crate repository"))
			end
		end)
	end,
	opts = {
		lsp = {
			enabled = true,
			actions = true,
			completion = true,
			hover = true,
		},
	},
}
