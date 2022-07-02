vim.api.nvim_create_user_command("Replacer", function()
  require("replacer").run()
end, { nargs = 0 })
