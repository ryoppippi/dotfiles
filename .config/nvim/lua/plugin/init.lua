vim.g.jetpack_copy_method = "symlink"
vim.g.jetpack_optimization = 1
vim.g.jetpack_njobs = 16
-- vim.g.enabled_snippet = "vsnip"
vim.g.enabled_snippet = "luasnip"

-- check if jetpack is installed
local status, _ = require("utils.plugin").load("vim-jetpack")
if not status then
  vim.cmd([[
        let dir = expand(stdpath('data') ..'/site/pack/jetpack/opt/vim-jetpack')
        if !isdirectory(dir)
          let url = 'https://github.com/tani/vim-jetpack'
          execute printf('!git clone %s %s', url, dir)
        endif
        packadd vim-jetpack
      ]])
end

local jp = require("jetpack")

local plugin_list = {
  -- Plugin management {{
  { "tani/vim-jetpack", opt = true, frozen = true },
  { "lewis6991/impatient.nvim", opt = true },
  { "tweekmonster/startuptime.vim" },
  -- }}

  -- Essential libraries {{
  { "nvim-lua/plenary.nvim" },
  { "kkharji/sqlite.lua" },
  { "ray-x/guihua.lua" },
  { "MunifTanjim/nui.nvim" },
  { "nvim-lua/popup.nvim" },
  { "rcarriga/nvim-notify" },
  { "kyazdani42/nvim-web-devicons" },
  { "tpope/vim-repeat" },
  { "monaqa/peridot.vim" },
  { "antoinemadec/FixCursorHold.nvim" },
  { "vim-denops/denops.vim" },
  { "echasnovski/mini.nvim", branch = "stable" },
  -- }}

  -- StatusLine {{
  { "feline-nvim/feline.nvim" },
  { "SmiteshP/nvim-gps" },
  { "SmiteshP/nvim-navic" },
  -- }}

  -- Other UI Components {{
  { "jeffkreeftmeijer/vim-numbertoggle" },
  { "mvllow/modes.nvim" },
  { "petertriho/nvim-scrollbar" },
  -- }}

  -- Moving Cursor {{
  { "unblevable/quick-scope" },
  { "yutkat/wb-only-current-line.nvim" },
  { "deton/jasegment.vim" }, -- Japanese word moving
  -- }}

  -- File Management {{

  -- filer {{
  { "nvim-neo-tree/neo-tree.nvim", branch = "v2.x" },
  -- }}

  -- window
  { "kwkarlwang/bufresize.nvim" },
  { "simeji/winresizer" },

  -- buffer
  -- { "stevearc/stickybuf.nvim" },
  { "famiu/bufdelete.nvim" },

  -- buffer move
  { "Bakudankun/BackAndForward.vim" },

  -- file format settings
  { "spywhere/detect-language.nvim" },
  { "Shougo/context_filetype.vim" },
  { "lfilho/cosco.vim" },
  { "nmac427/guess-indent.nvim" },
  -- { "zsugabubus/crazy8.nvim" },

  -- root dir
  { "ahmedkhalf/project.nvim" },

  -- }}

  -- Editing {{

  -- textobj
  { "kana/vim-textobj-user" },
  { "osyo-manga/vim-textobj-blockwise" },

  -- edit and insert
  { "thinca/vim-partedit" },

  -- brackets and parentheses
  { "machakann/vim-sandwich" },
  { "andymass/vim-matchup" },
  { "windwp/nvim-autopairs" },
  { "windwp/nvim-ts-autotag" },
  { "RRethy/nvim-treesitter-endwise" },
  -- { "abecodes/tabout.nvim" },
  -- { "cohama/lexima.vim" },

  -- comment
  -- commentout
  { "numToStr/Comment.nvim" },
  -- comment generation
  { "s1n7ax/nvim-comment-frame" },
  { "LudoPinelli/comment-box.nvim" },
  { "danymat/neogen" },

  -- yank and paste
  { "gbprod/substitute.nvim" },
  { "hrsh7th/nvim-pasta" },
  { "Rasukarusan/nvim-block-paste" },
  { "yuki-yano/deindent-yank.vim" },
  -- { "gbprod/yanky.nvim" },
  -- { "AckslD/nvim-anywise-reg.lua" },

  -- Select
  { "terryma/vim-expand-region" },
  { "terryma/vim-multiple-cursors" },
  { "kana/vim-niceblock" },

  -- Swap Arguments
  { "machakann/vim-swap" },

  -- Join
  { "AckslD/nvim-trevJ.lua" },

  -- Adding,subtracting,change cases
  { "monaqa/dial.nvim", opt = true },
  { "deris/vim-rengbang" },
  -- }}

  -- Builtin Enhancements {{
  -- Quickfix
  { "thinca/vim-qfreplace" },
  { "itchyny/vim-qfedit" },
  { "kevinhwang91/nvim-bqf", ft = "qf" },
  { "gabrielpoca/replacer.nvim" },

  -- Undo
  { "simnalamburt/vim-mundo" },

  -- Diff
  { "AndrewRadev/linediff.vim" },

  -- Macro
  { "zdcthomas/medit" },

  -- Register
  { "tversteeg/registers.nvim", branch = "main" },

  -- Mark
  { "chentoast/marks.nvim" },

  -- Fold
  -- { "lambdalisue/readablefold.vim" },
  { "monaqa/pretty-fold.nvim", branch = "for_stable_neovim" },

  -- Docs
  { "thinca/vim-ref" },
  { "folke/which-key.nvim" },
  { "nanotee/luv-vimdocs" },

  -- SpellCorrect
  { "lewis6991/spellsitter.nvim" },

  -- Command
  { "wsdjeg/vim-fetch" },
  { "jghauser/mkdir.nvim" },
  { "sQVe/sort.nvim" },
  { "tyru/capture.vim" },

  -- Terminal
  { "akinsho/toggleterm.nvim" },
  { "lambdalisue/guise.vim" },

  -- Session
  -- { "rmagatti/auto-session" },

  -- }}

  -- New Features {{

  -- Browser
  { "tyru/open-browser.vim" },
  { "tyru/open-browser-github.vim" },
  { "tyru/open-browser-unicode.vim" },

  -- Screenshot
  { "segeljakt/vim-silicon" },

  -- Template
  { "mattn/vim-sonictemplate" },

  -- Color Management
  { "max397574/colortils.nvim" },

  -- Git support{{
  -- client
  { "TimUntersberger/neogit" },

  -- git command assistant
  { "rhysd/committia.vim" },
  { "hotwatermorning/auto-git-diff" },
  { "akinsho/git-conflict.nvim" },
  { "sindrets/diffview.nvim" },
  { "yutkat/convert-git-url.nvim" },

  -- show messages
  { "lewis6991/gitsigns.nvim" },
  { "rhysd/git-messenger.vim" },

  -- Github
  { "pwntester/octo.nvim" },
  { "skanehira/denops-gh.vim" },

  -- }}

  -- Docker {{
  { "skanehira/denops-docker.vim" },
  -- }}

  -- REST {{
  { "NTBBloodbath/rest.nvim" },
  -- }}

  -- GraphAPI {{
  { "skanehira/denops-graphql.vim" },
  -- }}

  -- Shell {{
  { "lambdalisue/vim-manpager" },
  -- }}

  -- }}

  -- Search {{
  { "haya14busa/vim-asterisk" },
  { "hrsh7th/vim-searchx" },
  { "monaqa/modesearch.vim" },
  { "kevinhwang91/nvim-hlslens", as = "hlslens" },
  -- }}

  -- Rename {{
  { "smjonas/inc-rename.nvim", as = "inc_rename" },
  -- }}

  -- Fuzzy Finder {{
  -- Telescope {{
  { "nvim-telescope/telescope.nvim" },
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-file-browser.nvim" },
  { "nvim-telescope/telescope-frecency.nvim" },
  { "nvim-telescope/telescope-fzf-native.nvim", run = "make" },
  { "nvim-telescope/telescope-media-files.nvim" },
  { "nvim-telescope/telescope-symbols.nvim" },
  { "nvim-telescope/telescope-ghq.nvim" },
  { "nvim-telescope/telescope-github.nvim" },
  { "LinArcX/telescope-env.nvim" },
  { "crispgm/telescope-heading.nvim" },
  { "LinArcX/telescope-changes.nvim" },
  { "tknightz/telescope-termfinder.nvim" },
  { "benfowler/telescope-luasnip.nvim", enabled = vim.g.enabled_snippet == "luasnip" },
  -- }}

  -- }}

  -- Languages
  -- Nvim-LSP {{
  { "neovim/nvim-lspconfig", as = "lspconfig", opt = true },
  { "williamboman/nvim-lsp-installer" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "lukas-reineke/lsp-format.nvim" },

  -- UI
  { "onsails/lspkind.nvim" },
  { "folke/lsp-colors.nvim" },
  { "j-hui/fidget.nvim" },
  { "folke/trouble.nvim" },
  { "rmagatti/goto-preview" },
  -- }}
  -- }}

  -- Nvim-cmp {{
  { "hrsh7th/nvim-cmp", as = "cmp", opt = true },
  { "hrsh7th/cmp-nvim-lsp", as = "cmp_nvim_lsp", opt = true },
  { "hrsh7th/cmp-nvim-lsp-document-symbol", opt = true },
  { "hrsh7th/cmp-nvim-lua", opt = true },
  { "hrsh7th/cmp-nvim-lsp-signature-help", opt = true },
  { "hrsh7th/cmp-buffer", opt = true },
  { "hrsh7th/cmp-path", opt = true },
  { "hrsh7th/cmp-cmdline", opt = true },
  { "hrsh7th/cmp-calc", opt = true },
  { "hrsh7th/cmp-omni", opt = true },
  { "hrsh7th/cmp-emoji", opt = true },
  { "lukas-reineke/cmp-rg", opt = true },
  { "lukas-reineke/cmp-under-comparator", opt = true },
  { "f3fora/cmp-spell", opt = true },
  { "ray-x/cmp-treesitter", opt = true },
  { "yutkat/cmp-mocword", opt = true },
  -- { "petertriho/cmp-git", as = "cmp_git", opt = true },
  { "hrsh7th/cmp-vsnip", opt = true, enabled = vim.g.enabled_snippet == "vsnip" },
  { "saadparwaiz1/cmp_luasnip", opt = true, enabled = vim.g.enabled_snippet == "luasnip" },
  { "ryoppippi/cmp-copilot", branch = "dev/add-copilot-loaded-detecter", opt = true },
  -- { "hrsh7th/cmp-copilot", opt = true },
  -- { "uga-rosa/cmp-dictionary", opt = true },
  -- { "tzachar/cmp-tabnine", run = "./install.sh" },
  -- { "octaltree/cmp-look", opt = true },
  -- }}

  -- Nvim-treesitter {{
  { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" },
  { "yioneko/nvim-yati" },
  { "JoosepAlviste/nvim-ts-context-commentstring" },

  -- textobj
  { "nvim-treesitter/nvim-treesitter-textobjects" },
  { "RRethy/nvim-treesitter-textsubjects" },
  { "David-Kunz/treesitter-unit" },

  -- UI
  { "haringsrob/nvim_context_vt" },
  { "romgrk/nvim-treesitter-context" },
  -- }}

  -- ColorScheme {{
  { "navarasu/onedark.nvim" },
  { "ray-x/starry.nvim" },
  { "rebelot/kanagawa.nvim" },
  -- }}

  -- Heiglighting {{
  { "norcalli/nvim-colorizer.lua" },
  { "folke/todo-comments.nvim" },
  { "m-demare/hlargs.nvim" },
  { "p00f/nvim-ts-rainbow" },
  { "RRethy/vim-illuminate", as = "illuminate" },
  -- }}

  -- Snippets {{
  { "hrsh7th/vim-vsnip", enabled = (vim.g.enabled_snippet == "vsnip") },
  { "L3MON4D3/LuaSnip", as = "luasnip", enabled = (vim.g.enabled_snippet == "luasnip"), opt = true },

  -- utils
  { "kevinhwang91/nvim-hclipboard", as = "hclipboard" }, -- prevent polluting clipboard
  -- { "smjonas/snippet-converter.nvim" },

  -- snippets collection {{
  { "craigmac/vim-vsnip-snippets" },
  { "honza/vim-snippets" },
  { "rafamadriz/friendly-snippets" },
  -- }}

  -- language specific snippets {{
  -- go
  { "golang/vscode-go" },
  -- python
  { "cstrap/flask-snippets" },
  { "cstrap/python-snippets" },
  -- web
  { "fivethree-team/vscode-svelte-snippets" },
  { "xabikos/vscode-javascript" },
  -- }}

  -- }}

  -- Language specific plugins {{
  -- javascript
  { "vuki656/package-info.nvim" },
  { "bennypowers/nvim-regexplainer", as = "regexplainer" },
  -- typescript
  { "jose-elias-alvarez/typescript.nvim" },
  { "dhruvasagar/vim-table-mode" },
  -- sql
  { "jsborjesson/vim-uppercase-sql" },
  -- lua
  { "milisims/nvim-luaref" },
  { "folke/lua-dev.nvim" },
  -- rust
  { "simrat39/rust-tools.nvim" },
  -- go
  { "ray-x/go.nvim" },
  -- markdown
  -- { "previm/previm", ft = { "markdown", "pandoc.markdown", "rmd" } },
  {
    "iamcco/markdown-preview.nvim",
    as = "markdown-preview.nvim",
    run = ":call mkdp#util#install()",
    ft = { "markdown", "pandoc.markdown", "rmd" },
  },
  -- { "SidOfc/mkdx", ft = { "markdown" } },
  -- log
  { "mtdl9/vim-log-highlighting" },
  -- csv
  -- { "chen244/csv-tools.lua" },
  { "mechatroner/rainbow_csv", ft = { "csv" } },
  -- json
  { "b0o/schemastore.nvim" },
  -- swift
  -- { "xbase-lab/xbase", run = "make install" },
  -- }}

  -- AI {{
  { "github/copilot.vim", on = { "InsertEnter" } },
  -- }}

  -- Debug {{
  { "sentriz/vim-print-debug" },
  -- }}

  -- REPL {{
  { "hkupty/iron.nvim" },
  -- }}

  -- Test {{
  { "nvim-neotest/neotest" },
  -- }}

  -- Task Runner{{
  { "yutkat/taskrun.nvim" },
  -- { "michaelb/sniprun", run = "bash ./install.sh", opt = true },
  { "thinca/vim-quickrun" },
  { "lambdalisue/vim-quickrun-neovim-job" },
  -- }}

  -- Neovim
  { "wadackel/nvim-syntax-info" },
  { "bfredl/nvim-luadev" },
  -- }}

  -- Something fun {{
  { "ryoppippi/bad-apple.vim", branch = "main" },
  -- }}
}

for i, v in ipairs(plugin_list) do
  plugin_list[i].as = v.as or vim.fn.fnamemodify(v[1], ":t:r")
end

local startup_list = {
  -- preload for vimscript plugins
  "copilot",
  "vim-print-debug",
  "auto-session",
  -- should be loaded on startup
  "telescope",
  "todo-comments",
  "nvim-treesitter",
  "feline",
  "xbase",
  -- idk but defer_fn doesn't work for this plugin
  "nvim-lsp-installer",
}

-- load plugins
jp.startup(function(use)
  for _, plugin in ipairs(plugin_list) do
    local enabled = plugin.enabled
    if enabled ~= false then
      use(plugin)
    end
  end
end)

-- load plugin configs
local config_dir = vim.fn.stdpath("config") .. "/lua/plugin/config/"
local fd = vim.loop.fs_scandir(config_dir)
if fd then
  while true do
    local file_name, type = vim.loop.fs_scandir_next(fd)
    if not file_name then
      break
    end
    if type == "file" then
      local plugin_name = file_name:gsub("%.lua$", "")
      local file_path = config_dir .. file_name
      -- local plugin_name = vim.fn.fnamemodify(file_name, ":t:r")
      if jp.tap(plugin_name) then
        if vim.tbl_contains(startup_list, plugin_name) then
          vim.api.nvim_create_autocmd("VimEnter", {
            callback = function()
              vim.cmd("luafile " .. file_path)
            end,
          })
        else
          vim.defer_fn(function()
            vim.cmd("luafile " .. file_path)
          end, 0)
        end
      end
    end
  end
end

-- check if all plugins are istalled
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    for _, name in ipairs(jp.names()) do
      if not tb(jp.tap(name)) then
        jp.sync()
        pcall(vim.api.nvim_command, "LuaCacheClear")
        vim.cmd("source $MYVIMRC")
        break
      end
    end
  end,
})

vim.api.nvim_create_user_command("JetpackOpenURL", function(tbl)
  local url = jp.get(tbl.args).url
  vim.api.nvim_command("!open " .. url)
end, {
  nargs = 1,
  complete = function()
    return jp.names()
  end,
})

vim.api.nvim_create_user_command("JetpackReadme", function(tbl)
  local path = jp.get(tbl.args).path .. "/readme.md"
  local bufnr = vim.fn.bufadd(path)
  local ok, Popup = pcall(require, "nui.popup")
  if not ok then
    vim.api.nvim_command("e " .. path)
    return
  end
  local popup = Popup({
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
    },
    position = "50%",
    size = {
      width = "80%",
      height = "80%",
    },
    bufnr = bufnr,
    buf_options = {
      modifiable = false,
      readonly = true,
    },
  })
  popup:mount()
  popup:on("BufLeave", function()
    popup:unmount()
  end)
  popup:map("n", "<esc>", function()
    popup:unmount()
  end, { noremap = true })
end, {
  nargs = 1,
  complete = function()
    return jp.names()
  end,
})
