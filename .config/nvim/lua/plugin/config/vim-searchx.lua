local function hl_start()
  require("hlslens").start()
end

return {
  "hrsh7th/vim-searchx",
  -- lazy = false,
  event = "VeryLazy",
  dependencies = { "kevinhwang91/nvim-hlslens" },
  keys = {
    {
      "?",
      function()
        hl_start()
        vim.fn["searchx#start"]({ dir = 0 })
      end,
      mode = { "n", "x" },
    },
    {
      "/",
      function()
        hl_start()
        vim.fn["searchx#start"]({ dir = 1 })
      end,
      mode = { "n", "x" },
    },
    {
      ";",
      function()
        hl_start()
        vim.fn["searchx#start"]({ dir = 0 })
      end,
      mode = { "n", "x" },
    },
    {
      "?",
      function()
        hl_start()
        vim.fn["searchx#select"]()
      end,
      mode = { "n", "x" },
    },
    {
      "n",
      function()
        hl_start()
        vim.fn["searchx#next"]()
      end,
      mode = { "n", "x" },
    },
    {
      "N",
      function()
        hl_start()
        vim.fn["searchx#prev"]()
      end,
      mode = { "n", "x" },
    },
  },
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
      return a:input[0] .. substitute(a:input[1:], '\\\@<! ', '.\\{-}', 'g')
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
