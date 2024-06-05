---@type LazySpec
return {
	"fabridamicelli/cronex.nvim",
	event = "BufReadPost",
	opts = {
		file_patterns = {
			"*.yaml",
			"*.yml",
			"*.tf",
			"*.cfg",
			"*.config",
			"*.conf",
			"*.json",
			"*.ts",
			"*.js",
		},
		explainer = {
			cmd = { "bun", "x", "cronstrue" },
		},
	},
}
