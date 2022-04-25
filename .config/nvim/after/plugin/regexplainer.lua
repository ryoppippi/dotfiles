local plugin_name = "regexplainer"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	require(plugin_name).setup({
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
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
