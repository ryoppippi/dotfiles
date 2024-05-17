local function complete(arg_lead, _, _)
	local items = vimx.fn.tsnip.items()
	local words = vim.iter(items):map(function(item)
		return item.word
	end)
	words = words:filter(function(w)
		return tb(vim.startswith(w, arg_lead))
	end)
	words = words:totable()
	return words
end

local function redefineCmd()
	if vim.fn.exists(":TSnip") > 0 then
		vim.api.nvim_del_user_command("TSnip")
	end
	vim.api.nvim_create_user_command("TSnip", function(tbl)
		local args = tbl.args
		vim.print(args)
		vimx.fn.denops.request("tsnip", "execute", { args })
	end, {
		nargs = 1,
		complete = complete,
		desc = "Execute tsnip",
	})
end

---@type LazySpec
return {
	"https://github.com/yuki-yano/tsnip.nvim",
	event = { "User DenopsReady" },
	dependencies = { "vim-denops/denops.vim", "tani/vim-artemis" },
	init = function()
		vim.g.tsnip_snippet_dir = vim.fs.joinpath(vim.fn.stdpath("config"), "tsnip")
		vim.api.nvim_create_autocmd("User", {
			pattern = "DenopsPluginPost:tsnip",
			callback = redefineCmd,
		})
	end,
	config = function(spec)
		require("denops-lazy").load(spec.name)
	end,
}
