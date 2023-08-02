return {
	"rhysd/committia.vim",
	enabled = false,
	dependencies = { "tani/vim-artemis" },
	event = "VeryLazy",
	ft = { "gitcommit" },
	config = function()
		-- vim.g.committia_hooks = {
		-- 	edit_open = function(info)
		-- 		if info.vcs == "git" and vim.fn.getline(1) == "" then
		-- 		end
		-- 	end,
		-- }
		local bufname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
		if bufname == "COMMIT_EDITMSG" or bufname == "MERGE_MSG" then
			vimx.fn.committia.open("git")
		end
	end,
}
