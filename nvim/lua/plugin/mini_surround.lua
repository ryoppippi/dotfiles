return {
	"echasnovski/mini.surround",
	version = "*",
	event = "VeryLazy",
	enabled = true,
	opts = {
		mappings = {
			add = "sa", -- Add surrounding in Normal and Visual modes
			delete = "sd", -- Delete surrounding
			find = "sf", -- Find surrounding (to the right)
			find_left = "sF", -- Find surrounding (to the left)
			highlight = "", -- Highlight surrounding
			replace = "sr", -- Replace surrounding
			update_n_lines = "sn", -- Update `n_lines`
			suffix_last = "l", -- Suffix to search with "prev" method
			suffix_next = "n", -- Suffix to search with "next" method
		},
		custom_surroundings = {
			-- from https://github.com/atusy/dotfiles/blob/d387c4e1fdacfd971e349eccdd4860505d51c367/dot_config/nvim/lua/plugins/textobj.lua#L146-L199
			t = {
				input = { "<(%w-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- from https://github.com/echasnovski/mini.surround/blob/14f418209ecf52d1a8de9d091eb6bd63c31a4e01/lua/mini/surround.lua#LL1048C13-L1048C72
				output = function()
					local emmet = require("mini.surround").user_input("Emmet")
					if not emmet then
						return nil
					end
					local tag, residue
					tag, residue = emmet:match("^%s*([^#.[]+)(.+)")
					local attr = {
						["#"] = {},
						["."] = {},
						["[]"] = {},
					}
					for a in residue:gmatch("%b[]") do
						local value = string.match(a, ".(.*).")
						table.insert(attr["[]"], value)
					end
					for a in residue:gsub("%b[]", ""):gmatch("[.#][^.#]+") do
						local key, value = string.match(a, "(.)(.+)")
						table.insert(attr[key], value)
					end

					if #attr["#"] > 1 then
						error("id should be unique")
					end

					local left = { tag }
					if attr["#"][1] then
						table.insert(left, string.format('id="%s"', attr["#"][1]))
					end
					if attr["."][1] then
						table.insert(left, string.format('class="%s"', table.concat(attr["."], " ")))
					end
					if attr["[]"][1] then
						table.insert(left, attr["[]"][1] and table.concat(attr["[]"], " "))
					end
					return {
						left = string.format("<%s>", table.concat(left, " ")),
						right = string.format("</%s>", tag),
					}
				end,
			},
		},
	},
	config = function(_, opts)
		-- use gz mappings instead of s to prevent conflict with leap
		require("mini.surround").setup(opts)
	end,
}
