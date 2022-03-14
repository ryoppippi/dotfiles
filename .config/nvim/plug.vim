let g:enable_nvim_lsp = v:true
let g:enable_ddc = v:false
let g:enable_cmp = v:true

let g:enable_coc = v:false

let g:enable_copilot = v:true

let g:enable_wilder = v:false

if exists('g:vscode')
  let g:enable_cmp = v:false
  let g:enable_coc = v:false
  let g:enable_nvim_lsp = v:false
  let g:enable_ddc = v:false
  let g:enable_copilot = v:false
endif

if empty(glob('$HOME/.local/share/nvim/site/autoload/plug.vim'))
  if !executable('curl')
    echoerr 'You have to install curl.'
    execute 'quit!'
  endif
  silent !curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif


function! Cond(Cond, ...)
  let opts = get(a:000, 0, {})
  return a:Cond ? opts : extend(opts, { 'on': [], 'for': [] })
endfunction

function! UpdateRemotePlugins(...)
  " Needed to refresh runtime files
  let &rtp=&rtp
  UpdateRemotePlugins
endfunction

call plug#begin(stdpath('data') . '/plugged')

Plug 'vim-denops/denops.vim'
Plug 'haya14busa/vim-asterisk'
Plug 'thinca/vim-quickrun'
Plug 'thinca/vim-qfreplace'
Plug 'tyru/open-browser.vim'
Plug 'tyru/open-browser-github.vim'
Plug 'karb94/neoscroll.nvim'
Plug 'monaqa/dps-dial.vim'
Plug 'folke/which-key.nvim'
Plug 'echasnovski/mini.nvim', { 'branch': 'stable', 'on':[]}
Plug 'terryma/vim-expand-region'


" text objects
Plug 'phaazon/hop.nvim'
" Plug 'skanehira/jumpcursor.vim'
Plug 'hrsh7th/vim-searchx'
Plug 'machakann/vim-sandwich'
Plug 'alvan/vim-closetag'
Plug 'kana/vim-textobj-user'
Plug 'tpope/vim-unimpaired'
Plug 'osyo-manga/vim-textobj-blockwise'
Plug 'thinca/vim-textobj-between'
Plug 'tpope/vim-repeat'
Plug 'kana/vim-operator-user'
Plug 'kana/vim-operator-replace'
Plug 'cohama/lexima.vim'
Plug 'chen244/csv-tools.lua'
Plug 'yuki-yano/deindent-yank.vim'

" fern
if !exists('vscode')
  Plug 'antoinemadec/FixCursorHold.nvim'
  Plug 'lambdalisue/fern.vim'
  Plug 'lambdalisue/fern-git-status.vim'
  Plug 'lambdalisue/nerdfont.vim'
  Plug 'lambdalisue/fern-renderer-nerdfont.vim'
  Plug 'lambdalisue/glyph-palette.vim'
  Plug 'lambdalisue/fern-hijack.vim'
  Plug 'yuki-yano/fern-preview.vim'
  Plug 'jghauser/mkdir.nvim'
endif

" telescope
if !exists('vscode')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-file-browser.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'folke/todo-comments.nvim'
endif

" git
if !exists('vscode')
  " Plug 'lambdalisue/gina.vim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'rhysd/git-messenger.vim'
endif


" commentout
" Plug 'tpope/vim-commentary'
Plug 'numToStr/Comment.nvim'

if !exists('g:vscode') && g:enable_copilot
  Plug 'github/copilot.vim', { 'as': 'copilot', 'on': [] }
endif


" session, file management
if !exists('g:vscode')
  Plug 'nathom/filetype.nvim'
  Plug 'simeji/winresizer'
  Plug 'jeffkreeftmeijer/vim-numbertoggle'
  " Plug 'Pocco81/AutoSave.nvim'
  Plug 'rmagatti/auto-session'
endif

" visualize
if !exists('g:vscode')
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'navarasu/onedark.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'norcalli/nvim-colorizer.lua'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kdheepak/tabline.nvim'
endif

" language support 
Plug 'evanleck/vim-svelte'
" Plug 'mattn/emmet-vim', { 'for': ['html', 'svelte', 'tsx', 'jsx'] }
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'p00f/nvim-ts-rainbow'
Plug 'andymass/vim-matchup'
Plug 'yioneko/nvim-yati'
Plug 'arthurxavierx/vim-caser'

" Plug 'yardnsm/vim-import-cost', { 'do': 'npm install --production' }


if g:enable_coc 
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'honza/vim-snippets'
  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
  let g:enable_wilder = v:true
endif

if g:enable_nvim_lsp
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'tami5/lspsaga.nvim', {'commit': '0bf5602d6ee81f815dcd11d6090106b8e71c2f82'}
  Plug 'onsails/lspkind-nvim'
  Plug 'jose-elias-alvarez/null-ls.nvim'
  Plug 'rafamadriz/friendly-snippets'
  Plug 'hrsh7th/vim-vsnip'
  " Plug 'ray-x/lsp_signature.nvim'
endif

if g:enable_cmp
  " cmp
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'lukas-reineke/cmp-rg'
  Plug 'tzachar/cmp-tabnine', { 'do': './install.sh' }
  Plug 'ray-x/cmp-treesitter'
  Plug 'hrsh7th/cmp-emoji'
  " Plug 'octaltree/cmp-look'
  Plug 'hrsh7th/cmp-calc'
  Plug 'hrsh7th/cmp-nvim-lua'
  Plug 'hrsh7th/cmp-nvim-lsp-signature-help'
  Plug 'hrsh7th/cmp-copilot'
endif

if g:enable_ddc
  Plug 'Shougo/ddc.vim'
  Plug 'vim-denops/denops.vim'
  Plug 'Shougo/pum.vim'
  Plug 'Shougo/ddc-around'
  Plug 'Shougo/ddc-nvim-lsp'
  Plug 'Shougo/ddc-matcher_head'
  Plug 'Shougo/ddc-sorter_rank'
  Plug 'tani/ddc-fuzzy'
  Plug 'matsui54/ddc-converter_truncate'
  Plug 'Shougo/ddc-converter_remove_overlap'
  Plug 'matsui54/denops-popup-preview.vim'
  " Plug 'matsui54/denops-signature_help'
  Plug 'LumaKernel/ddc-tabnine'
  Plug 'LumaKernel/ddc-file'
  Plug 'Shougo/ddc-rg'
  Plug 'Shougo/ddc-cmdline'
  Plug 'Shougo/ddc-cmdline-history'
  Plug 'hrsh7th/vim-vsnip-integ'
  Plug 'Shougo/neco-vim'
  Plug 'matsui54/ddc-dictionary'
  Plug 'Shougo/ddc-omni'
  Plug 'gamoutatsumi/ddc-emoji'
  Plug 'octaltree/cmp-look'
  Plug 'delphinus/ddc-treesitter'

  Plug 'gelguy/wilder.nvim', { 'do': function('UpdateRemotePlugins') }
  let g:enable_wilder = v:true
endif

" web
Plug 'fivethree-team/vscode-svelte-snippets'
Plug 'stordahl/sveltekit-snippets'
Plug 'xabikos/vscode-javascript'
Plug 'craigmac/vim-vsnip-snippets'

" go
Plug 'golang/vscode-go'

" python
Plug 'cstrap/flask-snippets'
Plug 'cstrap/python-snippets'



call plug#end()


" 足りないプラグインがあれば :PlugInstall を実行
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
      \| PlugInstall --sync | source $MYVIMRC
      \| endif


if !exists('g:vscode')
  let g:rainbow_active = 1
  let g:completion_trigger_character = ['.']
  let g:did_load_filetypes = 1

  let g:minimap_width = 10
  let g:minimap_auto_start = 1
  let g:minimap_auto_start_win_enter = 1
endif

let g:user_emmet_leader_key=','
