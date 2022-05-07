-- let g:sonictemplate_vim_template_dir = [
--       \ fnamemodify($MYVIMRC, ':h') . '/template'
--       \]
vim.g.sonictemplate_vim_template_dir = { vim.fn.fnamemodify(vim.fn.expand('$MYVIMRC'), ':h') .. '/template' }
