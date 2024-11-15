---@type LazySpec
return {
	"https://github.com/nvim-neotest/neotest",
	cmd = { "Neotest" },
	keys = {

		{ "nt", "Neotest", mode = "ca" },
		{ "ntr", "Neotest run", mode = "ca" },
		{ "nts", "Neotest summary", mode = "ca" },
		{ "nto", "Neotest output-panel", mode = "ca" },
	},
	dependencies = {
		{
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		"https://github.com/marilari88/neotest-vitest",
		"https://github.com/MarkEmmons/neotest-deno",
		"https://github.com/lawrence-laz/neotest-zig",
	},
	opts = function()
		return {
			adapters = {
				require("neotest-vitest"),
				require("neotest-deno"),
				require("neotest-zig")({
					dap = {
						adapter = "lldb",
					},
				}),
			},
		}
	end,
}
