function! s:load_plug(timer)
  call plug#load(
  \ 'mini.nvim',
  \ )

lua << EOF
  local statusC, cursorword = pcall(require, 'mini.cursorword')
  if (not statusC) then return end
  cursorword.setup()

  local status, indent = pcall(require, 'mini.indentscope')
  if (not status) then return end
  indent.setup()

  local statusJ, jump = pcall(require, 'mini.jump')
  if (not statusJ) then return end
  jump.setup({
    mappings = {
      forward = 'f',
      backward = 'F',
      forward_till = 't',
      backward_till = 'T',
      repeat_jump = '',
    },

    -- Delay (in ms) between jump and highlighting all possible jumps. Set to
    -- a very big number (like 10^7) to virtually disable highlighting.
    highlight_delay = 250,
  })
EOF

endfunction

call timer_start(20, function("s:load_plug"))

