local utils_plug = require("utils.plugin")

local function hl_start()
  local hlslens = utils_plug.force_require("hlslens")
  return hlslens and hlslens.start()
end

local function keymap()
  vim.keymap.set({ "n", "x" }, "?", function()
    vim.fn["searchx#start"]({ dir = 0 })
  end)
  vim.keymap.set({ "n", "x" }, "/", function()
    vim.fn["searchx#start"]({ dir = 1 })
  end)
  vim.keymap.set("c", ";", vim.fn["searchx#select"])
  vim.keymap.set({ "n", "x" }, "N", function()
    vim.fn["searchx#prev"]()
    hl_start()
  end)
  vim.keymap.set({ "n", "x" }, "n", function()
    vim.fn["searchx#next"]()
    hl_start()
  end)
end

local function loading()
  vim.api.nvim_exec(
    [[
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
  ]],
    true
  )
  vim.api.nvim_create_autocmd("User", {
    pattern = { "SearchxAccept", "SearchxAcceptMarker", "SearchxAcceptReturn" },
    callback = hl_start,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = { "SearchxLeave", "SearchxCancel" },
    command = "nohlsearch",
  })
end

keymap()
loading()
