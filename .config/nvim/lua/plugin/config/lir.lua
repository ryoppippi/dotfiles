local plugin_name = "lir"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local actions = require("lir.actions")
  local mark_actions = require("lir.mark.actions")
  local clipboard_actions = require("lir.clipboard.actions")

  require("lir").setup({
    show_hidden_files = false,
    devicons_enable = true,
    mappings = {
      ["l"] = actions.edit,
      ["<C-s>"] = actions.split,
      ["<C-v>"] = actions.vsplit,
      ["<C-t>"] = actions.tabedit,

      ["h"] = actions.up,
      ["q"] = actions.quit,

      ["K"] = actions.mkdir,
      ["N"] = actions.newfile,
      ["R"] = actions.rename,
      ["@"] = actions.cd,
      ["Y"] = actions.yank_path,
      ["."] = actions.toggle_show_hidden,
      ["D"] = actions.delete,

      ["J"] = function()
        mark_actions.toggle_mark()
        vim.cmd("normal! j")
      end,
      ["C"] = clipboard_actions.copy,
      ["X"] = clipboard_actions.cut,
      ["P"] = clipboard_actions.paste,
    },
    float = {
      winblend = 0,
      curdir_window = {
        enable = false,
        highlight_dirname = false,
      },

      -- -- You can define a function that returns a table to be passed as the third
      -- -- argument of nvim_open_win().
      -- win_opts = function()
      --   local width = math.floor(vim.o.columns * 0.8)
      --   local height = math.floor(vim.o.lines * 0.8)
      --   return {
      --     border = {
      --       "+", "─", "+", "│", "+", "─", "+", "│",
      --     },
      --     width = width,
      --     height = height,
      --     row = 1,
      --     col = math.floor((vim.o.columns - width) / 2),
      --   }
      -- end,
    },
    hide_cursor = true,
    on_init = function()
      vim.keymap.set("x", "J", function()
        mark_actions.toggle_mark("v")
      end, { noremap = true, silent = true, buffer = true })

      -- echo cwd
      vim.api.nvim_echo({ { vim.fn.expand("%:p"), "Normal" } }, false, {})
    end,
  })
end

function keymap()
  vim.keymap.set("n", "<leader>e", function()
    require("lir.float").init()
  end, { noremap = true, silent = true })
end

keymap()

require("utils.plugin").force_load_on_event(plugin_name, loading)
