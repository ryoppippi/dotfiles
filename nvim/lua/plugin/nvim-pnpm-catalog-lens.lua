---@type LazySpec
return {
	"ryoppippi/nvim-pnpm-catalog-lens",
	dev = true,
	ft = { "json" },
	init = function()
		vim.g.pnpm_catalog_display = "inlay"
	end,
}
