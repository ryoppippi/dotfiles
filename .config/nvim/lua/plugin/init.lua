local tb = require("utils").toboolean
local function init()
  vim.g.enable_copilot = true
  vim.g.enable_nvim_lsp = true
  vim.g.enable_cmp = true
  vim.g.enable_ddc = false
  vim.g.enable_coc = false
  vim.g.enable_fern = false

  vim.g["jetpack#copy_method"] = "symlink"
  vim.g["jetpack#optimization"] = 1
end

local function ensure_jetpack()
  local status, _ = pcall(vim.cmd, "packadd vim-jetpack")
  if not status then
    vim.api.nvim_exec(
      [[
        let dir = expand(stdpath('data') ..'/site/pack/jetpack/src/vim-jetpack')
        if !isdirectory(dir)
          autocmd VimEnter * JetpackSync | source $MYVIMRC
          let url = 'https://github.com/tani/vim-jetpack'
          silent execute printf('!git clone --depth 1 %s %s', url, dir)
        endif
        silent execute 'ln -sf ~/.local/share/nvim/site/pack/jetpack/{src,opt}/vim-jetpack'
        packadd vim-jetpack
      ]],
      false
    )
  end
end

local function load_plugin_list()
  ensure_jetpack()
  vim.fn["jetpack#begin"]()
  vim.api.nvim_exec(
    [[
  " Jetpack 'tani/vim-jetpack', { 'opt': 1 }
  Jetpack 'ryoppippi/vim-jetpack', { 'opt': 1, 'branch': 'dev/add-dummy-command' }
  Jetpack 'lewis6991/impatient.nvim', { 'as': 'impatient', 'opt': 1}
  Jetpack 'vim-denops/denops.vim'
  Jetpack 'haya14busa/vim-asterisk',{'as': 'asterisk', 'on': '<Plug>(asterisk-'}
  Jetpack 'thinca/vim-quickrun',
  Jetpack 'thinca/vim-qfreplace'
  Jetpack 'tyru/open-browser.vim'
  Jetpack 'tyru/open-browser-github.vim'
  Jetpack '4513ECHO/vim-readme-viewer', { 'on': 'JetpackReadme'}
  Jetpack 'monaqa/dps-dial.vim',{'on':'VimEnter', 'as':'dial'}
  " Jetpack 'mopp/vim-operator-convert-case'
  Jetpack 'AckslD/nvim-trevJ.lua', {'as':'trevj', 'on':'VimEnter'}
  Jetpack 'deris/vim-rengbang'
  Jetpack 'folke/which-key.nvim',{'on':'VimEnter','as':'which-key'}
  Jetpack 'echasnovski/mini.nvim', { 'branch': 'stable', 'as': 'mini' }
  Jetpack 'terryma/vim-expand-region',  { 'on': '<Plug>(expand_region_' }
  Jetpack 'bennypowers/nvim-regexplainer' , { 'on': 'VimEnter' ,'as':'regexplainer' }

  Jetpack 'rhysd/clever-f.vim', {'as': 'clever-f'}
  Jetpack 'deton/jasegment.vim'

  Jetpack 'pianocomposer321/yabs.nvim'

  Jetpack 'segeljakt/vim-silicon', {'on': 'VimEnter'}

  Jetpack 'gabrielpoca/replacer.nvim'

  Jetpack 'tyru/capture.vim'
  Jetpack 'sQVe/sort.nvim', {'on':'VimEnter', 'as': 'sort'}

  Jetpack 'zdcthomas/medit'

  Jetpack 'mattn/vim-sonictemplate'

  Jetpack 'tversteeg/registers.nvim', { 'branch': 'main' }

  " text objects
  Jetpack 'phaazon/hop.nvim', { 'on': 'VimEnter', 'as':'hop'}
  " Jetpack 'bkad/CamelCaseMotion'
  Jetpack 'unblevable/quick-scope'
  Jetpack 'hrsh7th/vim-searchx', { 'as': 'searchx' }
  Jetpack 'kevinhwang91/nvim-hlslens', {'as': 'hlslens'}
  Jetpack 'machakann/vim-sandwich'
  Jetpack 'machakann/vim-swap'
  " Jetpack 'tpope/vim-unimpaired'
  " Jetpack 'osyo-manga/vim-textobj-blockwise'
  Jetpack 'tpope/vim-repeat'
  " Jetpack 'cohama/lexima.vim', { 'as': 'lexima' }
  Jetpack 'windwp/nvim-autopairs',
  Jetpack 'chen244/csv-tools.lua', { 'as': 'csvtools' }
  Jetpack 'yuki-yano/deindent-yank.vim'
  Jetpack 'numToStr/Comment.nvim', { 'as' : 'Comment' }
  Jetpack 'LudoPinelli/comment-box.nvim'

  Jetpack 'AndrewRadev/linediff.vim'

  Jetpack 'gbprod/substitute.nvim', { 'on': 'VimEnter', 'as': 'substitute' }
  Jetpack 'Rasukarusan/nvim-block-paste'

  " Jetpack 'rmagatti/auto-session'

  Jetpack 'akinsho/toggleterm.nvim', {'as': 'toggleterm', 'on': 'VimEnter'}

  Jetpack 'skanehira/denops-docker.vim', {'on': 'VimEnter'}


  " file explorer
    if g:enable_fern
      Jetpack 'lambdalisue/fern.vim', { 'as': 'fern'}
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

  " telescope
    Jetpack 'nvim-lua/plenary.nvim'
    Jetpack 'nvim-telescope/telescope.nvim', { 'as': 'telescope', 'on': 'VimEnter' }
    Jetpack 'nvim-telescope/telescope-file-browser.nvim'
    Jetpack 'nvim-telescope/telescope-frecency.nvim'
      Jetpack 'tami5/sqlite.lua'
    Jetpack 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Jetpack 'nvim-telescope/telescope-media-files.nvim'
    Jetpack 'crispgm/telescope-heading.nvim'
    Jetpack 'LinArcX/telescope-changes.nvim'
    Jetpack 'nvim-telescope/telescope-ui-select.nvim'
    Jetpack 'folke/todo-comments.nvim', {'as':'todo-comments', 'on':'BufReadPost'}

  " git
    Jetpack 'lewis6991/gitsigns.nvim',{ 'on': 'VimEnter', 'as': 'gitsigns'}
    Jetpack 'rhysd/git-messenger.vim'
    Jetpack 'akinsho/git-conflict.nvim',{ 'on': 'VimEnter', 'as': 'git-conflict'}
    Jetpack 'tanvirtin/vgit.nvim', { 'on': 'VimEnter', 'as': 'vgit' }
    Jetpack 'lambdalisue/gin.vim', { 'on': 'VimEnter', 'as': 'gin' }

  if  g:enable_copilot
    Jetpack 'github/copilot.vim', { 'on': [ 'CursorHold', 'InsertEnter']}
    " Jetpack  'zbirenbaum/copilot.lua'
  endif


  " visualize
    " Jetpack 'rcarriga/nvim-notify', {'as': 'notify', 'on': 'VimEnter'}
    " Jetpack 'jeffkreeftmeijer/vim-numbertoggle'
    Jetpack 'kyazdani42/nvim-web-devicons'
    " Jetpack 'hoob3rt/lualine.nvim', { 'as': 'lualine', 'on': 'VimEnter' }
    Jetpack 'feline-nvim/feline.nvim', { 'on': 'VimEnter', 'as': 'feline' }
    " Jetpack 'nanozuki/tabby.nvim', {'as': 'tabby' }
    " Jetpack 'petertriho/nvim-scrollbar',{ 'on': 'VimEnter', 'as': 'scrollbar'}
    Jetpack 'chentoast/marks.nvim', { 'on': 'VimEnter', 'as': 'marks'}
    Jetpack 'norcalli/nvim-colorizer.lua', { 'on': 'VimEnter', 'as': 'colorizer'}
    Jetpack 'mvllow/modes.nvim', { 'on': 'ModeChanged', 'as': 'modes'}
    " Jetpack 'VonHeikemen/fine-cmdline.nvim'
    Jetpack 'simeji/winresizer'
    Jetpack 'tkmpypy/chowcho.nvim', { 'on': 'VimEnter', 'as': 'chowcho' }

    Jetpack 'ulwlu/elly.vim', { 'opt': v:true }
    Jetpack 'navarasu/onedark.nvim', { 'as': 'onedark'}
    Jetpack 'ray-x/starry.nvim', {'as': 'starry'}
    " Jetpack 'marko-cerovac/material.nvim'
    Jetpack 'sainnhe/gruvbox-material'
    " Jetpack 'tribela/vim-transparent'

  " language support
  " Jetpack 'mattn/emmet-vim', { 'for': ['html', 'svelte', 'tsx', 'jsx'] }
  Jetpack 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate'}
  Jetpack 'nvim-treesitter/nvim-treesitter-textobjects'
  Jetpack 'vigoux/architext.nvim'
  Jetpack 'RRethy/nvim-treesitter-textsubjects'
  " Jetpack 'nvim-treesitter/nvim-treesitter-refactor'
  Jetpack 'mfussenegger/nvim-ts-hint-textobject'
  Jetpack 'David-Kunz/treesitter-unit'
  Jetpack 'JoosepAlviste/nvim-ts-context-commentstring'
  Jetpack 'SmiteshP/nvim-gps'
  Jetpack 'romgrk/nvim-treesitter-context'
  Jetpack 'haringsrob/nvim_context_vt'
  Jetpack 'windwp/nvim-ts-autotag'
  Jetpack 'andymass/vim-matchup'
  Jetpack 'nvim-treesitter/nvim-tree-docs'
  Jetpack 'm-demare/hlargs.nvim'
  Jetpack 'p00f/nvim-ts-rainbow'
  Jetpack 'mizlan/iswap.nvim', { 'on': ['ISwap', 'ISwapWith'], 'as': 'iswap' }
  Jetpack 'yioneko/nvim-yati', {'on': 'VimEnter', 'as': 'yati'}
  " Jetpack 'arthurxavierx/vim-caser'
  Jetpack 'danymat/neogen', {'on': 'VimEnter'}

  if g:enable_coc
    Jetpack 'neoclide/coc.nvim', {'branch': 'release', 'as': 'coc'}
    Jetpack 'honza/vim-snippets'
    Jetpack 'gelguy/wilder.nvim', { 'do': function('UpdateRemoteJetpackins'), 'as': 'wilder' }
  endif

  if g:enable_nvim_lsp
    Jetpack 'neovim/nvim-lspconfig', { 'opt': v:true,  'as': 'lspconfig'}
    Jetpack 'williamboman/nvim-lsp-installer', { 'opt': v:true }
    " Jetpack 'tami5/lspsaga.nvim', {'on': 'VimEnter', 'as': 'lspsaga' }
    Jetpack 'onsails/lspkind.nvim' , { 'as': 'lspkind' }
    " Jetpack 'HallerPatrick/py_lsp.nvim'
    Jetpack 'jose-elias-alvarez/null-ls.nvim', {'as': 'null-ls', 'on': 'VimEnter'}
    Jetpack 'kevinhwang91/nvim-hclipboard', {'on': 'VimEnter', 'as': 'hclipboard'}
    Jetpack 'folke/lsp-colors.nvim', { 'as': 'lsp-colors'}
    Jetpack 'RRethy/vim-illuminate', { 'opt': v:true, 'as': 'illuminate' }
    " Jetpack 'ray-x/lsp_signature.nvim'
    Jetpack 'j-hui/fidget.nvim', {'as': 'fidget', 'on': 'VimEnter'}

  endif

  if g:enable_cmp
    " cmp
    Jetpack 'hrsh7th/nvim-cmp', {'as': 'cmp', 'on': 'VimEnter'}
    Jetpack 'hrsh7th/cmp-buffer', {'opt': v:true }
    Jetpack 'hrsh7th/cmp-path', {'opt': v:true }
    Jetpack 'hrsh7th/cmp-nvim-lsp', { 'as': 'cmp_nvim_lsp', 'opt': v:true }
    Jetpack 'hrsh7th/cmp-nvim-lsp-document-symbol',{'opt': v:true}
    Jetpack 'hrsh7th/cmp-nvim-lua',{'opt': v:true}
    Jetpack 'hrsh7th/cmp-nvim-lsp-signature-help',{'opt': v:true}
    Jetpack 'hrsh7th/cmp-cmdline',{'opt': v:true}
    Jetpack 'lukas-reineke/cmp-rg',{'opt': v:true}
    Jetpack 'lukas-reineke/cmp-under-comparator',{'opt': v:true}
    " Jetpack 'tzachar/cmp-tabnine', { 'do': './install.sh' }
    Jetpack 'ray-x/cmp-treesitter',{'opt': v:true}
    Jetpack 'hrsh7th/cmp-emoji',{'opt': v:true}
    " Jetpack 'octaltree/cmp-look',{'opt': v:true}
    Jetpack 'hrsh7th/cmp-calc',{'opt': v:true}
    Jetpack 'petertriho/cmp-git', {'as': 'cmp_git', 'opt': v:true}
    if g:enable_copilot
      " Jetpack 'hrsh7th/cmp-copilot', {'opt': v:true}
      Jetpack 'ryoppippi/cmp-copilot', {'branch': 'dev/add-copilot-loaded-detecter', 'opt': v:true}
      " Jetpack 'zbirenbaum/copilot-cmp',{'opt': v:true}
    endif
    " Jetpack 'hrsh7th/cmp-vsnip'
    Jetpack 'saadparwaiz1/cmp_luasnip', {'opt': v:true}
  endif

  if g:enable_ddc
    Jetpack 'Shougo/ddc.vim', {'as': 'ddc'}
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
  Jetpack 'previm/previm'

  Jetpack 'ryoppippi/bad-apple.vim',{'branch':'main'}
  ]],
    false
  )
  vim.fn["jetpack#end"]()
end

local function check_installed()
  for _, name in ipairs(vim.fn["jetpack#names"]()) do
    if not tb(vim.fn["jetpack#tap"](name)) then
      vim.fn["jetpack#sync"]()
      vim.api.nvim_exec([[source $MYVIMRC]])
      break
    end
  end
end

local function load_lua_configs()
  for _, path in ipairs(vim.fn.glob(vim.fn.stdpath("config") .. "/lua/plugin/config/*.lua", 1, 1, 1)) do
    vim.cmd(string.format("luafile %s", vim.fn.fnameescape(path)))
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    check_installed()
  end,
})

init()
load_plugin_list()
load_lua_configs()
