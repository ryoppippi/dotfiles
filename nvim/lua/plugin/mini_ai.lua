-- TODO: replace nvim-treesitter-textobjects with mini.ai
---@type LazySpec
return {
	"echasnovski/mini.ai",
	branch = "stable",
	event = { "BufReadPost", "BufNew" },
	opts = function()
		vim.keymap.set({ "x", "o" }, "A", function()
			local ctrl_v = vim.keycode("<C-v>")
			local mode = vim.api.nvim_get_mode().mode
			return mode == ctrl_v and "A" or "ae"
		end, { remap = true, expr = true, desc = "Select entire buffer when not in visual block mode" })

		local gen_ai_spec = require("mini.extra").gen_ai_spec
		return {
			custom_textobjects = {
				e = gen_ai_spec.buffer(),
				D = gen_ai_spec.diagnostic(),
				I = gen_ai_spec.indent(),
				L = gen_ai_spec.line(),
				N = gen_ai_spec.number(),
				J = { { "()%d%d%d%d%-%d%d%-%d%d()", "()%d%d%d%d%/%d%d%/%d%d()" } },
			},
		}
	end,
}
