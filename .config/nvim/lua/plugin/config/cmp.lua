local plugin_name = "cmp"
local utils_plug = require("utils.plugin")

-- local snippet_library = 'vsnip'
local snippet_library = "luasnip"
if not utils_plug.is_exists(plugin_name) then
  return
end

vim.o.completeopt = "menuone,noinsert,noselect"

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local function loading()
  local cmp = require(plugin_name)
  local utils = require("utils")
  local t = utils.t
  local toboolean = utils.toboolean
  local vsnip_jumpable = vim.fn["vsnip#jumpable"]
  local _, luasnip = pcall(require, "luasnip")
  local snl = snippet_library

  for _, name in ipairs(utils_plug.names()) do
    if string.find(name, "cmp") then
      pcall(vim.cmd, string.format("packadd %s", name))
      local after_plugin_path = vim.fn.expand(utils_plug.get(name).path .. "/after/plugin")
      if vim.fn.isdirectory(after_plugin_path) then
        for _, path in ipairs(vim.fn.glob(after_plugin_path .. "/*{.lua,.vim}", 1, 1, 1)) do
          vim.cmd(string.format("source %s", vim.fn.fnameescape(path)))
        end
      end
    end
  end

  local setup_opt = {
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        if snl == "vsnip" then
          vim.fn["vsnip#anonymous"](args.body)
        elseif snl == "luasnip" then
          luasnip.lsp_expand(args.body)
        end
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ["<C-l>"] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ["<C-j>"] = cmp.mapping.select_next_item(),
      ["<C-k>"] = cmp.mapping.select_prev_item(),
      ["<C-d>"] = cmp.mapping.scroll_docs(-4),
      ["<C-f>"] = cmp.mapping.scroll_docs(4),
      ["<CR>"] = function(fallback)
        if cmp.visible() and cmp.get_selected_entry() ~= nil then
          cmp.confirm({ select = false })
        else
          fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
        end
      end,
      -- ["<Space>"] = function(fallback)
      --   if cmp.visible() then
      --     cmp.abort()
      --   else
      --     fallback() -- If you are using vim-endwise, this fallback function will be behaive as the vim-endwise.
      --   end
      -- end,
      ["<Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        elseif snl == "vsnip" and toboolean(vsnip_jumpable(1)) then
          vim.fn.feedkeys(t("<Plug>(vsnip-jump-next)"), "")
        elseif snl == "luasnip" and luasnip.jumpable(1) then
          -- luasnip.jump(1)
          luasnip.expand_or_jump()
        elseif has_words_before() then
          cmp.complete()
        else
          fallback()
        end
      end, { "i", "s" }),

      ["<S-Tab>"] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        elseif snl == "vsnip" and toboolean(vsnip_jumpable(-1)) then
          vim.fn.feedkeys(t("<Plug>(vsnip-jump-prev)"), "")
        elseif snl == "luasnip" and luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          if vim.g.loaded_copilot then
            vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](t("<Tab>")), "n", true)
          else
            fallback()
          end
        end
      end, { "i", "s" }),
    }),
    sources = cmp.config.sources({
      { name = "copilot" },
      { name = "nvim_lsp" },
      { name = "path" },
      -- { name = "fuzzy_path" },
      { name = "rg" },
      -- { name = "vsnip" },
      { name = "luasnip" },
      { name = "git" },
      { name = "nvim_lsp_document_symbol" },
      { name = "treesitter" },
      { name = "nvim_lua" },
      { name = "calc" },
      { name = "emoji" },
      { name = "look", keyword_length = 2, option = { convert_case = true, loud = true } },
      { name = "nvim_lsp_signature_help" },
    }, {
      { name = "buffer" },
      -- { name = "fuzzy_buffer" },
      -- { name = "cmp_tabnine" },
    }),
    completion = {
      completeopt = "menu,menuone,noinsert, noselect",
    },
    experimental = {
      ghost_text = false, -- this feature conflict to the copilot.vim's preview.
    },
  }

  local status_lspkind, lspkind = pcall(require, "lspkind")
  if status_lspkind then
    setup_opt.formatting = {
      format = lspkind.cmp_format({
        mode = "symbol",
        maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
        menu = {
          nvim_lsp = "[LSP]",
          buffer = "[Buffer]",
          fuzzy_buffer = "[FBuffer]",
          path = "[Path]",
          fuzzy_path = "[FPath]",
          nvim_lua = "[Lua]",
          ultisnips = "[UltiSnips]",
          vsnip = "[vSnip]",
          luasnip = "[LuaSnip]",
          treesitter = "[treesitter]",
          look = "[Look]",
          spell = "[Spell]",
          calc = "[Calc]",
          emoji = "[Emoji]",
          neorg = "[Neorg]",
          rg = "[rg]",
          cmp_tabnine = "[Tabnine]",
          nvim_lsp_signature_help = "[Signature]",
          copilot = "[Copilot]",
          -- cmp_openai_codex = "[Codex]",
        },
      }),
    }
  end

  cmp.setup(setup_opt)

  -- cmp.setup.cmdline("/", {
  --   mapping = cmp.mapping.preset.cmdline(),
  --   sources = {
  --     { name = "buffer" },
  --   },
  --   completion = {
  --     completeopt = "menu,menuone,noselect",
  --   },
  -- })

  cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = "cmdline" },
      -- { name = "path" },
      { name = "fuzzy_path" },
    }),
    completion = {
      completeopt = "menu,menuone,noselect",
    },
  })

  vim.cmd([[highlight! default link CmpItemKind CmpItemMenuDefault]])

  -- Setup tabnine
  local status_tn, _ = require("utils.plugin").force_require("cmp-tabnine")
  if status_tn then
    require("cmp_tabnine.config"):setup({
      max_lines = 1000,
      max_num_results = 5,
      sort = true,
      run_on_every_keystroke = true,
      snippet_placeholder = "..",
    })
  end

  -- Setup autopairs
  local status_autopairs, _ = require("utils.plugin").force_require("nvim-autopairs")
  if status_autopairs then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
    -- cmp_autopairs.lisp[#cmp_autopairs.lisp + 1] = "racket"
  end

  local status_git, cmp_git = require("utils.plugin").force_require("cmp_git")
  if status_git and cmp_git then
    cmp_git.setup()
  end
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
