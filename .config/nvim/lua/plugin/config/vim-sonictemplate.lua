-- let g:sonictemplate_vim_template_dir = [
--       \ fnamemodify($MYVIMRC, ':h') . '/template'
--       \]
vim.g.sonictemplate_vim_template_dir = { vim.fn.expand(vim.fn.stdpath("config") .. "/template") }
