local status, cmp = pcall(require, 'cmp')
if (not status) then return end

local function replace_keys(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end


local setup_opt = {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
      -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
      -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    end,
  },
  mapping = {
    ["<C-l>"] = cmp.mapping.abort(),
    ['<C-j>'] = cmp.mapping.select_next_item(),
    ['<C-k>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] =
    function(fallback)
      if cmp.visible() then
        cmp.confirm({ select = true })
      else
        fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
        end
      end,
      ['<Tab>'] = cmp.mapping(function(fallback)
        if vim.call('vsnip#jumpable', 1) ~= 0 then
          vim.fn.feedkeys(replace_keys('<Plug>(vsnip-jump-next)'), '')
        elseif cmp.visible() then
          cmp.select_next_item()
        -- elseif vim.b._copilot_suggestion ~= nil  then
          --   vim.fn.feedkeys(vim.api.nvim_replace_termcodes(vim.fn['copilot#Accept'](), true, true, true), '')
        else
          vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<C-%>', true, true, true), '')
          -- fallback()
        end
      end, { 'i', 's' }),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if vim.call('vsnip#jumpable', -1) ~= 0 then
        vim.fn.feedkeys(replace_keys('<Plug>(vsnip-jump-prev)'), '')
      elseif cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { 'i', 's' }),
},
sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'buffer' },
    { name = 'vsnip' },
    { name = "treesitter" },
    { name = 'nvim_lua' },
    { name = 'calc' },
    { name = 'cmp_tabnine' },
    { name = 'emoji' },
    { name = 'look', keyword_length=2, option={convert_case=true, loud=true} },
  }),
completion = {
  completeopt = 'menu,menuone,noinsert'
},
}


local status_lspkind, lspkind = pcall(require, 'lspkind')
if status_lspkind then
  setup_opt.formatting = {
    format = lspkind.cmp_format({
        with_text = false, -- do not show text alongside icons
          maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          menu = {
            nvim_lsp = "[LSP]",
            buffer = "[Buffer]",
            nvim_lua = "[Lua]",
            ultisnips = "[UltiSnips]",
            vsnip = "[vSnip]",
            treesitter = "[treesitter]",
            look = "[Look]",
            path = "[Path]",
            spell = "[Spell]",
            calc = "[Calc]",
            emoji = "[Emoji]",
            neorg = "[Neorg]",
            cmp_tabnine = "[Tabnine]",
            -- cmp_openai_codex = "[Codex]",
          },
        })
    }
  end

  cmp.setup(setup_opt)

  cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      },
      completion = {
        completeopt = 'menuone,noinsert,noselect'
      }
    })

  cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
          { name = 'path' }
        }, {
          { name = 'cmdline' }
        }),
      completion = {
        completeopt = 'menu,menuone,noselect'
      }
    })


  vim.o.completeopt = 'menuone,noinsert,noselect'

  vim.cmd [[highlight! default link CmpItemKind CmpItemMenuDefault]]

  -- Setup lspconfig.
  local status_lsp, cmp_lsp = pcall(require, 'cmp_nvim_lsp')
  if status_lsp then
    local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
  end

  -- Setup tabnine
  local status_tn, tabnine = pcall(require, 'cmp_tabnine.config')
  if status_tn then
    tabnine:setup({
        max_lines = 1000;
        max_num_results = 5;
        sort = true;
        run_on_every_keystroke = true;
	    snippet_placeholder = '..';
      })
  end
