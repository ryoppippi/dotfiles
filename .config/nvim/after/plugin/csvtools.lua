local plugin_name = "csvtools"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function loading()
	require(plugin_name).setup({
		before = 10,
		after = 10,
		clearafter = true,
		-- this will clear the highlight of buf after move
		showoverflow = true,
		-- this will provide a overflow show
		titelflow = true,
		-- add an alone title
	})
end

loading()
