if !plugin#is_exists('wilder') | finish | endif

call wilder#setup({'modes': [':', '/', '?']})
call wilder#set_option('renderer', wilder#popupmenu_renderer({
  \ 'highlighter': wilder#basic_highlighter(),
\ }))
