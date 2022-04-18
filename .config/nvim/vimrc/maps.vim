let mapleader = "\<Space>"

nnoremap ; :
nnoremap : ;
vnoremap ; :
vnoremap : ;

" Split window
if exists('g:vscode')
  nmap ss ;split<Return>
  nmap sv ;vsplit<Return>
else
  nmap ss ;split<Return><C-w>w
  nmap sv ;vsplit<Return><C-w>w
endif
" Move window
map sh <C-w>h
map sk <C-w>k
map sj <C-w>j
map sl <C-w>l

" Switch tab
nnoremap th  :tabfirst<CR>
nnoremap tk  :tabnext<CR>
nnoremap tj  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit . <CR>
nnoremap <leader>t :tabedit . <CR>
nnoremap tq  :tabclose<CR>

" 折り返し時に表示行単位での移動できるようにする
nnoremap j gj
nnoremap k gk

" 補完表示時のEnterで改行をしない
" inoremap <expr><CR>  pumvisible() ? '<C-y>': '<CR>'
" inoremap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"
" inoremap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"

inoremap <silent> jj <ESC>

noremap x "_x
nnoremap D "_D

nnoremap s <Nop>
nnoremap <leader>cc :cclose<CR>
