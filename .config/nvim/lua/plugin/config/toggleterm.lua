local plugin_name = "toggleterm"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local Terminal = require("toggleterm.terminal").Terminal
  local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "double",
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd("startinsert!")
      vim.keymap.set("n", "q", "<cmd>close<CR>", { noremap = true, silent = true, buffer = term.bufnr })
      vim.keymap.set("n", "<esc>", "<cmd>close<CR>", { noremap = true, silent = true, buffer = term.bufnr })
    end,
    -- function to run on closing the terminal
    on_close = function(term)
      vim.cmd("Closing terminal")
    end,
  })

  local function lazygit_toggle()
    lazygit:toggle()
  end

  vim.keymap.set("n", "<leader>ag", lazygit_toggle, { noremap = true, silent = true })
  vim.api.nvim_create_user_command("Lazygit", lazygit_toggle, { nargs = "*" })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
