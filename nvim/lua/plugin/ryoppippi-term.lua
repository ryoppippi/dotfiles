return {
  dir = "",
  name = "ryoppippi-term.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  cmd = { "T", "TS", "TV" },
  config = function()
    local function openTerm(args)
      local tf = vim.cmd.terminal
      if args == "" then
        tf()
      else
        tf(args)
      end
    end

    vim.api.nvim_create_user_command("T", function(tbl)
      local args = tbl.args
      vim.cmd.tabe()
      openTerm(args)
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("TS", function(tbl)
      local args = tbl.args
      local splitbelow = vim.o.splitbelow
      vim.opt.splitbelow = true
      vim.cmd.split()
      openTerm(args)
      vim.opt.splitbelow = splitbelow
    end, { nargs = "*" })

    vim.api.nvim_create_user_command("TV", function(tbl)
      local args = tbl.args
      local splitright = vim.o.splitright
      vim.opt.splitright = true
      vim.cmd.vsplit()
      openTerm(args)
      vim.opt.splitright = splitright
    end, { nargs = "*" })
  end,
}
