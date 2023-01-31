return {
  "hrsh7th/nvim-cmp",
  name = "cmp",
  event = { "InsertEnter", "CmdlineEnter" },
  dependencies = {
    { "onsails/lspkind.nvim" },
    { "hrsh7th/cmp-nvim-lsp", dependencies = { "neovim/nvim-lspconfig" } },
    { "hrsh7th/cmp-nvim-lsp-signature-help", dependencies = { "neovim/nvim-lspconfig" } },
    { "hrsh7th/cmp-nvim-lsp-document-symbol", dependencies = { "neovim/nvim-lspconfig" } },
    { "ray-x/cmp-treesitter", dependencies = { "nvim-treesitter/nvim-treesitter" } },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-calc" },
    { "hrsh7th/cmp-emoji" },
    { "lukas-reineke/cmp-rg" },
    { "lukas-reineke/cmp-under-comparator" },
    { "hrsh7th/cmp-nvim-lua" },
    {
      "roobert/tailwindcss-colorizer-cmp.nvim",
      config = {
        color_square_width = 2,
      },
    },
    { "f3fora/cmp-spell" },
    { "yutkat/cmp-mocword" },
    { "hrsh7th/cmp-vsnip", enabled = vim.g.enabled_snippet == "vsnip" },
    { "saadparwaiz1/cmp_luasnip", enabled = vim.g.enabled_snippet == "luasnip" },
    {
      "ryoppippi/cmp-copilot",
      enabled = false,
      branch = "dev/add-copilot-loaded-detecter",
      dependencies = { "github/copilot.vim" },
    },
    {
      "zbirenbaum/copilot-cmp",
      enabled = true,
      config = function()
        require("copilot_cmp").setup()
      end,
    },
    {
      "petertriho/cmp-git",
      name = "cmp_git",
      config = function()
        require("cmp_git").setup({})
      end,
    },
    -- { "hrsh7th/cmp-omni" },
    -- { "hrsh7th/cmp-copilot", dependencies = { "github/copilot.vim" } },
    -- { "uga-rosa/cmp-dictionary" },
    -- { "tzachar/cmp-tabnine", build = "./install.sh" },
    -- { "octaltree/cmp-look" },
  },
  config = function()
    local snippet_library = vim.g.enabled_snippet

    vim.o.completeopt = "menuone,noinsert,noselect"

    -- Setup dependencies
    local cmp = require("cmp")

    local types = require("cmp.types")
    local luasnip = require("luasnip")

    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    local snippet_jumpable = function(dir)
      if snippet_library == "vsnip" then
        return tb(vim.fn["vsnip#jumpable"](dir))
      elseif snippet_library == "luasnip" then
        return tb(luasnip.jumpable(dir))
      end
      return false
    end

    local snippet_jump = function(dir)
      if snippet_library == "vsnip" then
        if dir == 1 then
          vim.fn.feedkeys(t("<Plug>(vsnip-jump-next)"), "")
        elseif dir == -1 then
          vim.fn.feedkeys(t("<Plug>(vsnip-jump-prev)"), "")
        end
      elseif snippet_library == "luasnip" then
        luasnip.jump(dir)
      end
    end

    local setup_opt = {
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          if snippet_library == "vsnip" then
            vim.fn["vsnip#anonymous"](args.body)
          elseif snippet_library == "luasnip" then
            luasnip.lsp_expand(args.body)
          end
        end,
      },

      mapping = cmp.mapping.preset.insert({
        ["<C-l>"] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ["<C-y>"] = cmp.config.disable,
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),
        ["<C-d>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<CR>"] = function(fallback)
          local entry = cmp.get_selected_entry()
          if cmp.visible() and entry ~= nil then
            local confirm_option = {
              select = false,
              -- behavior = entry.source.name == "copilot" and cmp.ConfirmBehavior.Insert or cmp.ConfirmBehavior.Replace,
            }
            cmp.confirm(confirm_option)
          else
            fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
          end
        end,
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif snippet_jumpable(1) then
            snippet_jump(1)
          elseif has_words_before() then
            cmp.complete()
            -- elseif tb(vim.g.loaded_copilot) then
            --   vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t("<Tab>")), "n", true)
            -- elseif is_emmet_active() then
            --   cmp.complete()
          else
            fallback()
          end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif snippet_jumpable(-1) then
            snippet_jump(-1)
          elseif tb(vim.g.loaded_copilot) then
            vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t("<Tab>")), "n", true)
          else
            fallback()
          end
        end, { "i", "s" }),
      }),

      sorting = {
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          require("cmp-under-comparator").under,
          function(entry1, entry2)
            local kind1 = entry1:get_kind()
            kind1 = kind1 == types.lsp.CompletionItemKind.Text and 100 or kind1
            local kind2 = entry2:get_kind()
            kind2 = kind2 == types.lsp.CompletionItemKind.Text and 100 or kind2
            if kind1 ~= kind2 then
              if kind1 == types.lsp.CompletionItemKind.Snippet then
                return false
              end
              if kind2 == types.lsp.CompletionItemKind.Snippet then
                return true
              end
              local diff = kind1 - kind2
              if diff < 0 then
                return true
              elseif diff > 0 then
                return false
              end
            end
          end,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },

      sources = cmp.config.sources({
        { name = "copilot" },
        -- { name = "rg" },
        { name = "vsnip" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "emoji", insert = true },
        { name = "nvim_lua" },
        { name = "nvim_lsp_signature_help" },
      }, {
        { name = "buffer" },
        { name = "omni" },
        { name = "calc" },
        { name = "spell" },
        { name = "treesitter" },
        { name = "dictionary", keyword_length = 2 },
        { name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
        { name = "git" },
        -- { name = "cmp_tabnine" },
      }),
      completion = {
        completeopt = "menu,menuone,noinsert,noselect",
      },
      experimental = {
        ghost_text = false, -- this feature conflict to the copilot.vim's preview.
      },
    }

    setup_opt.formatting = {
      format = require("lspkind").cmp_format({
        mode = "symbol_text",
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        menu = {
          nvim_lsp = "[LSP]",
          buffer = "[Buffer]",
          path = "[Path]",
          nvim_lua = "[Lua]",
          ultisnips = "[UltiSnips]",
          vsnip = "[vSnip]",
          luasnip = "[LuaSnip]",
          treesitter = "[TS]",
          spell = "[Spell]",
          calc = "[Calc]",
          emoji = "[Emoji]",
          neorg = "[Neorg]",
          rg = "[rg]",
          omni = "[Omni]",
          -- cmp_tabnine = "[Tabnine]",
          nvim_lsp_signature_help = "[Signature]",
          copilot = "[Copilot]",
          cmdline_history = "[History]",
          mocword = "[Mocword]",
          dictionary = "[Dictionary]",
          look = "[Look]",
          git = "[Git]",
          -- cmp_openai_codex = "[Codex]",
        },
        before = require("tailwindcss-colorizer-cmp").formatter,
      }),
    }

    cmp.setup(setup_opt)

    cmp.setup.filetype({ "gitcommit", "octo", "markdown" }, {
      sources = cmp.config.sources({
        { name = "git" },
        { name = "copilot" },
        -- { name = "rg" },
        { name = "vsnip" },
        { name = "luasnip" },
        { name = "nvim_lsp" },
        { name = "path" },
        { name = "emoji", insert = true },
      }, {
        { name = "buffer" },
        { name = "omni" },
        { name = "spell" },
        { name = "calc" },
        { name = "treesitter" },
        { name = "mocword" },
        { name = "dictionary", keyword_length = 2 },
        { name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
      }),
    })

    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "nvim_lsp_document_symbol" },
        { name = "cmdline" },
      }, {
        { name = "buffer" },
      }),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" }, { { name = "cmdline_history" } } }),
      completion = {
        completeopt = "menu,menuone,noselect",
      },
    })

    vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])

    cmp.event:on("menu_opened", function()
      vim.b.copilot_suggestion_hidden = true
    end)

    cmp.event:on("menu_closed", function()
      vim.b.copilot_suggestion_hidden = false
    end)

    -- Setup autopairs
    -- local autopairs = require("nvim-autopairs")
    -- local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    -- cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    -- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
  end,
}
