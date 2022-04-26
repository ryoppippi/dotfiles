local plugin_name = "lualine"
if not require("utils.plugin").is_exists(plugin_name) then
	return
end

local function AS()
	if vim.g.autosave_state then
		return "AS"
	else
		return ""
	end
end

local function loading()
	local lualine = require(plugin_name)
	lualine.setup({
		options = {
			icons_enabled = true,
			theme = "auto",
			section_separators = { left = "", right = "" },
			component_separators = { left = "", right = "" },
			disabled_filetypes = {},
			globalstatus = true,
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch" },
			lualine_c = {
				{
					"filename",
					file_status = true, -- displays file status (readonly status, modified status)
					path = 0, -- 0 = just filename, 1 = relative path, 2 = absolute path
				},
			},
			lualine_x = {
				{
					"diagnostics",
					sources = { "nvim_diagnostic" },
					symbols = { error = " ", warn = " ", info = " ", hint = " " },
				},
				"encoding",
				"filetype",
				AS,
			},
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = {
				{
					"filename",
					file_status = true, -- displays file status (readonly status, modified status)
					path = 1, -- 0 = just filename, 1 = relative path, 2 = absolute path
				},
			},
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		extensions = { "fugitive" },
	})
	vim.cmd([[set noshowmode]])
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
