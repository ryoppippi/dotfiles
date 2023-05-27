local function hl_start()
	if require("core.plugin").has("nvim-hlslens") then
		require("hlslens").start()
	end
end

return {
	"hrsh7th/vim-searchx",
	enabled = true,
	dependencies = { "kevinhwang91/nvim-hlslens", "tani/vim-artemis", "lambdalisue/kensaku.vim" },
	keys = function()
		return {
			{
				"?",
				function()
					hl_start()
					vimx.fn.searchx.start({ dir = 0 })
				end,
				mode = { "n", "x" },
			},
			{
				"/",
				function()
					hl_start()
					vimx.fn.searchx.start({ dir = 1 })
				end,
				mode = { "n", "x" },
			},
			{
				":",
				function()
					hl_start()
					vimx.fn.searchx.select()
				end,
				mode = { "n" },
			},
			{
				";",
				function()
					hl_start()
					vimx.fn.searchx.select()
				end,
				mode = { "x" },
			},
			{
				"n",
				function()
					hl_start()
					vimx.fn.searchx.next()
				end,
				mode = { "n", "x" },
			},
			{
				"N",
				function()
					hl_start()
					vimx.fn.searchx.prev()
				end,
				mode = { "n", "x" },
			},
		}
	end,
	config = function()
		vim.cmd([[
    let g:searchx = {}

    " Auto jump if the recent input matches to any marker.
    let g:searchx.auto_accept = v:true

    " The scrolloff value for moving to next/prev.
    let g:searchx.scrolloff = &scrolloff

    " To enable scrolling animation.
    let g:searchx.scrolltime = 30

    " To enable auto nohlsearch after cursor is moved
    let g:searchx.nohlsearch = {}
    let g:searchx.nohlsearch.jump = v:true

    " Marker characters.
    let g:searchx.markers = split('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.\zs')

    " Convert search pattern.
    function g:searchx.convert(input) abort
      if a:input !~# '\k'
        return '\V' .. a:input
      endif
      " return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
      return kensaku#query(a:input)
      " return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
    endfunction
  ]])

		vim.api.nvim_create_autocmd("User", {
			pattern = { "SearchxAccept", "SearchxAcceptMarker", "SearchxAcceptReturn" },
			callback = hl_start,
		})
		vim.api.nvim_create_autocmd("User", {
			pattern = { "SearchxLeave", "SearchxCancel" },
			command = "nohlsearch",
		})
	end,
}
