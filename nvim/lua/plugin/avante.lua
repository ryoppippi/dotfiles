---@type LazySpec
return {
	"yetone/avante.nvim",
	event = "VeryLazy",
	enabled = false,
	version = false, -- set this if you want to always pull the latest change
	---@type avante.Config
	opts = {
		provider = "copilot",
	},
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	build = "make",
	-- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"stevearc/dressing.nvim",
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
		"zbirenbaum/copilot.lua", -- for providers='copilot'
		"HakonHarnes/img-clip.nvim",
		{
			-- Make sure to set this up properly if you have lazy=true
			"MeanderingProgrammer/render-markdown.nvim",
			opts = {
				file_types = {
					-- "markdown",
					"Avante",
				},
			},
			ft = {
				-- "markdown",
				"Avante",
			},
		},
	},
}
