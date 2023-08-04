return {
	"terryma/vim-expand-region",
	enabled = false,
	keys = {
		{ "v", "<Plug>(expand_region_expand)", mode = { "n", "v" } },
		{ "<c-v>", "<Plug>(expand_region_shrink)", mode = { "v" } },
	},
}
