local plugin_name = "neogit"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  local neogit = require("neogit")
  neogit.setup({
    disable_commit_confirmation = true,
    integrations = { diffview = true },
    sections = {
      stashes = {
        folded = false,
      },
      recent = { folded = false },
    },
  })

  vim.api.nvim_create_augroup("vimrc_neogit", { clear = true })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    group = "vimrc_neogit",
    pattern = { "NeogitCommitMessage" },
    callback = function()
      vim.cmd([[startinsert]])
    end,
    once = false,
  })
end

require("utils.plugin").force_load_on_event(plugin_name, loading)
