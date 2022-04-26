local plugin_name = "vgit"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	require("vgit").setup()
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
