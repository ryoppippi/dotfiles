return {
	"lambdalisue/vim-guise",
	dependencies = { "vim-denops/denops.vim" },
	event = { "User DenopsReady" },
	enabled = false,
	config = function()
		require("denops-lazy").load("vim-guise")
		vim.cmd([[
        let s:address = $GUISE_NVIM_ADDRESS
        if !empty(s:address)
            noautocmd call guise#open(s:address, argv())
        endif
      ]])
	end,
}
