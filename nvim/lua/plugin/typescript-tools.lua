return {
	"pmizio/typescript-tools.nvim",
	event = { "BufReadPost" },
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	enabled = false,
	opts = {
		settings = {
			tsserver_plugins = { "typescript-styled-plugin", "typescript-svelte-plugin" },
			tsserver_file_preferences = {
				quotePreference = "auto",
				includeCompletionsForModuleExports = true,
				includeInlayEnumMemberValueHints = true,
				includeInlayFunctionLikeReturnTypeHints = true,
				includeInlayFunctionParameterTypeHints = true,
				includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
				includeInlayParameterNameHintsWhenArgumentMatchesName = true,
				includeInlayPropertyDeclarationTypeHints = true,
				includeInlayVariableTypeHints = true,
			},
		},
	},
}
