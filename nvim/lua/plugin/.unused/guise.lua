return {
	"lambdalisue/guise.vim",
	dependencies = { "vim-denops/denops.vim" },
	event = { "User DenopsReady" },
	enabled = false,
	config = function()
		require("denops-lazy").load("guise.vim")
		vim.cmd([[
        let s:address = $GUISE_NVIM_ADDRESS
        if !empty(s:address)
            noautocmd call guise#open(s:address, argv())
        endif
      ]])
	end,
}
