local plugin_name = "toggleterm"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local create_cli = function(cmd)
  local Terminal = require("toggleterm.terminal").Terminal
  local tnew = Terminal:new({
    cmd = cmd,
    hidden = true,
    close_on_exit = true,
    dir = "git_dir",
    direction = "float",
    float_opts = {
      border = "double",
    },
    -- function to run on opening the terminal
    on_open = function(term)
      vim.cmd("startinsert!")
      -- vim.keymap.set("n", "q", "<cmd>close<cr>", { noremap = true, silent = true, buffer = term.bufnr })
      vim.keymap.set("t", "<esc>", "<esc>", { noremap = true, silent = true, buffer = term.bufnr })
    end,
  })

  local function toggle()
    tnew:toggle()
  end

  local upper_case = vim.fn.substitute(cmd, [[\<.]], [[\u&]], [[g]])
  vim.api.nvim_create_user_command(upper_case, toggle, { nargs = "*" })

  return toggle
end

local function loading()
  require("toggleterm").setup()
  local lazygit_toggle = create_cli("lazygit")
  local lazydocker_toggle = create_cli("lazydocker")
  local nyancat = create_cli("nyancat")

  vim.keymap.set("n", "<leader>gg", lazygit_toggle, { noremap = true, silent = true, desc = "toggle lazygit" })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
