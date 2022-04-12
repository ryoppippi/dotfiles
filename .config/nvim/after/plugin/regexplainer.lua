local status, regexplainer = pcall(require, "regexplainer")
if not status then
	return
end

regexplainer.setup({
	display = "popup",

	mappings = {
		toggle = "gR",
		-- examples, not defaults:
		-- show = 'gS',
		-- hide = 'gH',
		-- show_split = 'gP',
		-- show_popup = 'gU',
	},
})
