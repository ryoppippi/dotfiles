function open_cfile()
	-- if input is url, open it in browser
	-- if input is image file, vim.ui.open
	-- if input is file, open it in neovim
	-- if input is keywordtypescript source definition, open it in neovim
	-- if input is keyword and definition is found, open it in neovim
	-- if input is keyword and definition is not found, echo error
end

---@type LazySpec
return {
	"ryoppippi-gf",
	virtual = true,
	enabled = false,
	keys = {
		{
			"gf",
			function()
				open_cfile()
			end,
			mode = { "n", "v" },
			desc = "Open file/definition under cursor",
		},
	},
}
