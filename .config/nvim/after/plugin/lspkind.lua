local status, lspkind = pcall(require, "lspkind")
if not status then
	return
end
--
lspkind.setup({
	mode = "symbol_text",

	symbol_map = {
		Text = "",
		Method = "",
		Function = "",
		Constructor = "",
		Field = "ﰠ",
		Variable = "",
		Class = "ﴯ",
		Interface = "",
		Module = "",
		Property = "ﰠ",
		Unit = "",
		-- Value = "",
		Value = "",
		Enum = "",
		Keyword = "",
		Snippet = "",
		Color = "",
		File = "",
		Reference = "",
		Folder = "",
		EnumMember = "",
		Constant = "",
		Struct = "פּ",
		Event = "",
		Operator = "",
		TypeParameter = "",
		Namespace = "",
		Package = "",
		String = "",
		Number = "",
		Boolean = "",
		Array = "",
		Object = "",
		Key = "",
		Null = "ﳠ",
	},
})
