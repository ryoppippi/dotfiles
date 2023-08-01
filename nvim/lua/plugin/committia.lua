return {
	"rhysd/committia.vim",
	dependencies = { "tani/vim-artemis" },
	ft = { "gitcommit" },
	config = function()
		local bufname = vim.fs.basename(vim.api.nvim_buf_get_name(0))
		if bufname == "COMMIT_EDITMSG" or bufname == "MERGE_MSG" then
			vimx.fn.committia.open("git")
		end
	end,
}
