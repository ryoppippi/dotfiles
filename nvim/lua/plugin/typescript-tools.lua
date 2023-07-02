return {
	"pmizio/typescript-tools.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	enabled = false,
	opts = function()
		local lspfoncig_opts = require("lazy.core.config").plugins["nvim-lspconfig"].opts()
		local tih = lspfoncig_opts.typescriptInlayHints
		return {
			settings = {
				tsserver_plugins = { "typescript-styled-plugin", "typescript-svelte-plugin" },
				tsserver_file_preferences = {
					includeInlayEnumMemberValueHints = tih.enumMemberValues.enabled,
					includeInlayFunctionLikeReturnTypeHints = tih.functionLikeReturnTypes.enabled,
					includeInlayFunctionParameterTypeHints = tih.parameterTypes.enabled,
					includeInlayParameterNameHints = tih.parameterNames.enabled,
					includeInlayParameterNameHintsWhenArgumentMatchesName = tih.parameterNames.suppressWhenArgumentMatchesName,
					includeInlayPropertyDeclarationTypeHints = tih.propertyDeclarationTypes.enabled,
					includeInlayVariableTypeHints = tih.variableTypes.enabled,
				},
			},
		}
	end,
}
