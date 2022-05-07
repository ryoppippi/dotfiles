local plugin_name = "searchx"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function keymap()
  local opt = { noremap = true }
  vim.keymap.set({ "n", "x" }, "?", function()
    vim.fn["searchx#start"]({ dir = 0 })
  end, opt)
  vim.keymap.set({ "n", "x" }, "/", function()
    vim.fn["searchx#start"]({ dir = 1 })
  end, opt)
  vim.keymap.set("c", ";", vim.fn["searchx#select"], opt)
  vim.keymap.set({ "n", "x" }, "N", vim.fn["searchx#prev_dir"], opt)
  vim.keymap.set({ "n", "x" }, "n", vim.fn["searchx#prev_dir"], opt)
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
end

loading()
keymap()
