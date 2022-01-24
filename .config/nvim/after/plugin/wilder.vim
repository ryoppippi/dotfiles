" try
      " call wilder#setup({'modes': [':', '/', '?']})
      " call wilder#set_option('renderer', wilder#popupmenu_renderer({
      "       \ 'highlighter': wilder#basic_highlighter(),
      "       \ }))
" catch e
      " infomsg "no wilder"
" endtry
