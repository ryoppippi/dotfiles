local function AS()
	return vim.g.autosave_state and "AS" or ""
end

local chech_width = function()
	return vim.go.columns > 120
end

local function lsp_client_names()
	local clients = {}
	for _, client in pairs(vim.lsp.buf_get_clients(0)) do
		clients[#clients + 1] = client.name
	end

	return #clients > 0 and " " .. table.concat(clients, " ") or ""
end

return {
	"nvim-lualine/lualine.nvim",
	enabled = false,
	dependencies = {
		"SmiteshP/nvim-navic",
	},
	event = { "VimEnter" },
	config = function()
		local lualine = require("lualine")
		local _, navic = pcall(require, "nvim-navic")
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
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{
						"filename",
						file_status = true, -- displays file status (readonly status, modified status)
						shorting_target = 100,
						path = 1,

						cond = function()
							return chech_width()
						end,
					},
					{
						"filename",
						file_status = true, -- displays file status (readonly status, modified status)
						path = 0,
						cond = function()
							return not chech_width()
						end,
					},

					{
						function()
							return navic.get_location({ depth = 3 })
						end,
						cond = function()
							return navic ~= nil and navic.is_available() and chech_width()
						end,
					},
				},
				lualine_x = {
					-- {
					--   lsp_client_names,
					-- },
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
						colored = true,
					},
					"encoding",
					"fileformat",
					"filetype",
					"filesize",
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
		})
		vim.opt.showmode = false
	end,
}
