function! plugin#is_exists(name) 
	return jetpack#tap(a:name)
endfunction

function! CheckJetPackList()
  for name in jetpack#names()
    if !jetpack#tap(name)
      call jetpack#sync()
      source $MYVIMRC
      break
    endif
  endfor
endfunction


autocmd VimEnter * call CheckJetPackList()

