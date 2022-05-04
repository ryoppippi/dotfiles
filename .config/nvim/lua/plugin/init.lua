vim.g.enable_copilot = true
vim.g.enable_nvim_lsp = true
vim.g.enable_cmp = true
vim.g.enable_ddc = false
vim.g.enable_coc = false
vim.g.enable_fern = false

if require("utils").is_vscode() then
  vim.g.enable_copilot = false
  vim.g.enable_nvim_lsp = false
  vim.g.enable_cmp = false
  vim.g.enable_ddc = false
  vim.g.enable_coc = false
  vim.g.enable_fern = false
end

if vim.fn.empty(vim.fn.glob(vim.fn.stdpath("data") .. "/site/autoload/jetpack.vim")) == 1 then
  vim.api.nvim_exec(
    [[
    let jetpack = stdpath('data') . '/site/autoload/jetpack.vim'
    autocmd VimEnter * JetpackSync | source $MYVIMRC
    silent execute '!curl -fLo '.jetpack.' --create-dirs  https://raw.githubusercontent.com/tani/vim-jetpack/master/autoload/jetpack.vim'
  ]],
    false
  )
end

pcall(vim.cmd, "packadd jetpack")

vim.api.nvim_exec(
  [[
call jetpack#begin()
" Jetpack 'tani/vim-jetpack', { 'opt': 1 }
Jetpack 'ryoppippi/vim-jetpack', { 'opt': 1 , 'branch': 'dev/use-dictionary' }
Jetpack 'lewis6991/impatient.nvim', { 'as': 'impatient', 'opt': 1}
Jetpack 'vim-denops/denops.vim'
Jetpack 'haya14busa/vim-asterisk',{'as': 'asterisk', 'on': '<Plug>(asterisk-'}
Jetpack 'thinca/vim-quickrun'
Jetpack 'thinca/vim-qfreplace'
Jetpack 'tyru/open-browser.vim',{'on': 'VimEnter'}
Jetpack 'tyru/open-browser-github.vim', {'on': 'VimEnter'}
Jetpack '4513ECHO/vim-readme-viewer', { 'on': [ 'JetpackReadme', 'CursorHold'] }
Jetpack 'monaqa/dps-dial.vim',{'on':'VimEnter', 'as':'dial'}
" Jetpack 'mopp/vim-operator-convert-case'
Jetpack 'AckslD/nvim-trevJ.lua', {'as':'trevj', 'on':'VimEnter'}
Jetpack 'deris/vim-rengbang'
Jetpack 'folke/which-key.nvim',{'on':'VimEnter','as':'which-key'}
Jetpack 'echasnovski/mini.nvim', { 'branch': 'stable'}
Jetpack 'terryma/vim-expand-region',  { 'on': '<Plug>(expand_region_' }
Jetpack 'bennypowers/nvim-regexplainer' , { 'on': 'VimEnter' ,'as':'regexplainer' }

Jetpack 'rhysd/clever-f.vim', {'as': 'clever-f'}
Jetpack 'deton/jasegment.vim'

Jetpack 'pianocomposer321/yabs.nvim'

Jetpack 'segeljakt/vim-silicon'

Jetpack 'gabrielpoca/replacer.nvim'

Jetpack 'tyru/capture.vim'
Jetpack 'sQVe/sort.nvim', {'on':'VimEnter', 'as': 'sort'}

Jetpack 'zdcthomas/medit'

Jetpack 'mattn/vim-sonictemplate'

Jetpack 'tversteeg/registers.nvim', { 'branch': 'main' }

" text objects
Jetpack 'phaazon/hop.nvim', { 'on': 'VimEnter', 'as':'hop'}
" Jetpack 'skanehira/jumpcursor.vim'
Jetpack 'bkad/CamelCaseMotion'
Jetpack 'unblevable/quick-scope'
Jetpack 'hrsh7th/vim-searchx', { 'as': 'searchx' }
Jetpack 'kevinhwang91/nvim-hlslens', {'as': 'hlslens'}
Jetpack 'machakann/vim-sandwich'
Jetpack 'machakann/vim-swap'
" Jetpack 'tpope/vim-unimpaired'
" Jetpack 'osyo-manga/vim-textobj-blockwise'
Jetpack 'tpope/vim-repeat'
" Jetpack 'cohama/lexima.vim'
Jetpack 'windwp/nvim-autopairs', { 'on': ['InsertEnter','CursorHold']}
Jetpack 'chen244/csv-tools.lua', { 'as': 'csvtools' }
Jetpack 'yuki-yano/deindent-yank.vim'
Jetpack 'numToStr/Comment.nvim', { 'as' : 'Comment' }
Jetpack 'LudoPinelli/comment-box.nvim'

Jetpack 'AndrewRadev/linediff.vim'

Jetpack 'gbprod/substitute.nvim', { 'on': 'VimEnter', 'as': 'substitute' }

Jetpack 'rmagatti/auto-session'


" file explorer
if !exists('vscode')
  if g:enable_fern
    Jetpack 'lambdalisue/fern.vim'
    Jetpack 'lambdalisue/fern-git-status.vim'
    Jetpack 'lambdalisue/nerdfont.vim'
    Jetpack 'lambdalisue/fern-renderer-nerdfont.vim'
    Jetpack 'lambdalisue/glyph-palette.vim'
    Jetpack 'lambdalisue/fern-hijack.vim'
    Jetpack 'yuki-yano/fern-preview.vim'
    " Jetpack 'LumaKernel/fern-mapping-fzf.vim'
  endif
  Jetpack 'MunifTanjim/nui.nvim'
  Jetpack 'nvim-neo-tree/neo-tree.nvim', { 'as': 'neo-tree', 'branch': 'v2.x', 'on': 'VimEnter'}
  " Jetpack 'obaland/vfiler.vim', { 'on': 'VimEnter', 'as': 'vfiler' }
  " Jetpack 'obaland/vfiler-column-devicons', { 'on': 'VimEnter'}
  Jetpack 'antoinemadec/FixCursorHold.nvim'
  Jetpack 'jghauser/mkdir.nvim'
  Jetpack 'wsdjeg/vim-fetch'
  Jetpack 'kevinhwang91/nvim-bqf'
endif

" telescope
if !exists('vscode')
  Jetpack 'nvim-lua/plenary.nvim'
  Jetpack 'nvim-telescope/telescope.nvim', { 'as': 'telescope', 'on': 'VimEnter', 'commit': '6a54433038ce6d37e506ff9102ad7fcca121d58a', 'branch': 'master' }
  Jetpack 'nvim-telescope/telescope-file-browser.nvim'
  Jetpack 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Jetpack 'folke/todo-comments.nvim', {'as':'todo-comments', 'on':'BufReadPost'}
endif

" git
if !exists('vscode')
  " Jetpack 'lambdalisue/gina.vim'
  Jetpack 'lewis6991/gitsigns.nvim',{ 'on': 'VimEnter', 'as': 'gitsigns'}
  Jetpack 'rhysd/git-messenger.vim'
  Jetpack 'akinsho/git-conflict.nvim',{ 'on': 'VimEnter', 'as': 'git-conflict'}
  Jetpack 'tanvirtin/vgit.nvim', { 'on': 'VimEnter', 'as': 'vgit' }
  Jetpack 'lambdalisue/gin.vim', { 'on': 'VimEnter', 'as': 'gin' }
endif


if !exists('g:vscode') && g:enable_copilot
  Jetpack 'github/copilot.vim', { 'on': [ 'CursorHold', 'InsertEnter']}
  " Jetpack  "zbirenbaum/copilot.lua"
endif


" visualize
if !exists('g:vscode')
  " Jetpack 'rcarriga/nvim-notify', {'as': 'notify', 'on': 'VimEnter'}
  " Jetpack 'jeffkreeftmeijer/vim-numbertoggle'
  Jetpack 'kyazdani42/nvim-web-devicons'
  Jetpack 'hoob3rt/lualine.nvim', { 'as': 'lualine', 'on': 'VimEnter' }
  " Jetpack 'petertriho/nvim-scrollbar',{ 'on': 'VimEnter', 'as': 'scrollbar'}
  Jetpack 'chentau/marks.nvim', { 'on': 'VimEnter', 'as': 'marks'}
  Jetpack 'norcalli/nvim-colorizer.lua', { 'on': 'VimEnter', 'as': 'colorizer'}
  Jetpack 'mvllow/modes.nvim', { 'on': 'ModeChanged', 'as': 'modes'}
  " Jetpack 'VonHeikemen/fine-cmdline.nvim'
  Jetpack 'simeji/winresizer'
  Jetpack 'tkmpypy/chowcho.nvim', { 'on': 'VimEnter', 'as': 'chowcho' }

  Jetpack 'ulwlu/elly.vim', { 'opt': v:true }
  Jetpack 'navarasu/onedark.nvim', { 'as': 'onedark' }
  " Jetpack 'marko-cerovac/material.nvim'
  Jetpack 'sainnhe/gruvbox-material'
  " Jetpack 'tribela/vim-transparent'
  Jetpack 'j-hui/fidget.nvim', {'as': 'fidget', 'on': 'VimEnter'}
endif

" language support
" Jetpack 'mattn/emmet-vim', { 'for': ['html', 'svelte', 'tsx', 'jsx'] }
Jetpack 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
Jetpack 'nvim-treesitter/nvim-treesitter-textobjects'
Jetpack 'RRethy/nvim-treesitter-textsubjects'
Jetpack 'JoosepAlviste/nvim-ts-context-commentstring'
Jetpack 'romgrk/nvim-treesitter-context'
Jetpack 'haringsrob/nvim_context_vt'
Jetpack 'windwp/nvim-ts-autotag'
Jetpack 'andymass/vim-matchup'
Jetpack 'm-demare/hlargs.nvim'
Jetpack 'David-Kunz/treesitter-unit'
Jetpack 'p00f/nvim-ts-rainbow'
" Jetpack 'mizlan/iswap.nvim'
Jetpack 'yioneko/nvim-yati', {'on': 'VimEnter', 'as': 'yati'}
Jetpack 'arthurxavierx/vim-caser'
Jetpack 'danymat/neogen', {'on': 'VimEnter'}

if g:enable_coc
  Jetpack 'neoclide/coc.nvim', {'branch': 'release', 'as': 'coc'}
  Jetpack 'honza/vim-snippets'
  Jetpack 'gelguy/wilder.nvim', { 'do': function('UpdateRemoteJetpackins'), 'as': 'wilder' }
endif

if g:enable_nvim_lsp
  Jetpack 'neovim/nvim-lspconfig', { 'opt': v:true,  'as': 'lspconfig'}
  Jetpack 'williamboman/nvim-lsp-installer', { 'opt': v:true }
  Jetpack 'tami5/lspsaga.nvim', {'on': 'VimEnter', 'as': 'lspsaga' }
  Jetpack 'onsails/lspkind.nvim' , { 'as': 'lspkind' }
  " Jetpack 'HallerPatrick/py_lsp.nvim'
  Jetpack 'jose-elias-alvarez/null-ls.nvim', {'as': 'null-ls', 'on': 'VimEnter'}
  Jetpack 'kevinhwang91/nvim-hclipboard', {'on': 'VimEnter', 'as': 'hclipboard'}
  Jetpack 'folke/lsp-colors.nvim'
  Jetpack 'RRethy/vim-illuminate'
  " Jetpack 'ray-x/lsp_signature.nvim'
endif

if g:enable_cmp
  " cmp
  Jetpack 'hrsh7th/nvim-cmp', {'as': 'cmp', 'commit': 'bba6fb67fdafc0af7c5454058dfbabc2182741f4'}
  Jetpack 'hrsh7th/cmp-buffer',
  Jetpack 'hrsh7th/cmp-path',
  Jetpack 'hrsh7th/cmp-nvim-lsp', { 'as': 'cmp_nvim_lsp'}
  Jetpack 'hrsh7th/cmp-nvim-lsp-document-symbol',
  Jetpack 'hrsh7th/cmp-nvim-lua',
  Jetpack 'hrsh7th/cmp-nvim-lsp-signature-help',
  Jetpack 'tzachar/fuzzy.nvim'
  Jetpack 'tzachar/cmp-fuzzy-buffer'
  Jetpack 'tzachar/cmp-fuzzy-path'
  Jetpack 'hrsh7th/cmp-cmdline',
  Jetpack 'lukas-reineke/cmp-rg',
  " Jetpack 'tzachar/cmp-tabnine', { 'do': './install.sh' }
  Jetpack 'ray-x/cmp-treesitter', 
  Jetpack 'hrsh7th/cmp-emoji',
  " Jetpack 'octaltree/cmp-look',
  Jetpack 'hrsh7th/cmp-calc',
  Jetpack 'petertriho/cmp-git', {'as': 'cmp_git'}
  if g:enable_copilot
    " Jetpack 'hrsh7th/cmp-copilot',
    Jetpack 'ryoppippi/cmp-copilot', {'branch': 'dev/add-copilot-loaded-detecter'}
  " Jetpack 'zbirenbaum/copilot-cmp',
  endif
  " Jetpack 'hrsh7th/cmp-vsnip'
  Jetpack 'saadparwaiz1/cmp_luasnip'
endif

if g:enable_ddc
  Jetpack 'Shougo/ddc.vim'
  Jetpack 'vim-denops/denops.vim'
  Jetpack 'Shougo/pum.vim'
  Jetpack 'Shougo/ddc-around'
  Jetpack 'Shougo/ddc-nvim-lsp'
  Jetpack 'Shougo/ddc-matcher_head'
  Jetpack 'Shougo/ddc-sorter_rank'
  Jetpack 'tani/ddc-fuzzy'
  Jetpack 'matsui54/ddc-converter_truncate'
  Jetpack 'Shougo/ddc-converter_remove_overlap'
  Jetpack 'matsui54/denops-popup-preview.vim'
  " Jetpack 'matsui54/denops-signature_help'
  " Jetpack 'LumaKernel/ddc-tabnine'
  Jetpack 'LumaKernel/ddc-file'
  Jetpack 'Shougo/ddc-rg'
  Jetpack 'Shougo/ddc-cmdline'
  Jetpack 'Shougo/ddc-cmdline-history'
  " Jetpack 'hrsh7th/vim-vsnip-integ'
  Jetpack 'Shougo/neco-vim'
  Jetpack 'matsui54/ddc-dictionary'
  Jetpack 'Shougo/ddc-omni'
  Jetpack 'gamoutatsumi/ddc-emoji'
  Jetpack 'octaltree/cmp-look'
  Jetpack 'delphinus/ddc-treesitter'
  " Jetpack 'gelguy/wilder.nvim', { 'do': function('UpdateRemoteJetpackins'),'as': 'wilder' }
endif

" snippets
" library
" Jetpack 'hrsh7th/vim-vsnip', { 'on': 'VimEnter'}
Jetpack 'L3MON4D3/LuaSnip', { 'as': 'luasnip'}

Jetpack 'rafamadriz/friendly-snippets'
Jetpack 'honza/vim-snippets'
" Jetpack 'smjonas/snippet-converter.nvim'
" web
Jetpack 'fivethree-team/vscode-svelte-snippets'
Jetpack 'stordahl/sveltekit-snippets'
Jetpack 'xabikos/vscode-javascript'
" Jetpack 'craigmac/vim-vsnip-snippets'
" go
Jetpack 'golang/vscode-go'
" python
Jetpack 'cstrap/flask-snippets'
Jetpack 'cstrap/python-snippets'

" markdown
Jetpack 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install'  }

Jetpack 'ryoppippi/bad-apple.vim',{'branch':'main'}
call jetpack#end()

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

]],
  true
)
