local plugin_name = "hlslens"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local function loading()
  vim.api.nvim_create_autocmd("User", {
    pattern = { "SearchxAccept", "SearchxAcceptMarker" },
    callback = function()
      require(plugin_name).start()
    end,
  })
  vim.api.nvim_create_autocmd("User", {
    pattern = { "SearchxLeave", "SearchxCancel" },
    callback = function()
      vim.api.nvim_command("nohlsearch")
    end,
  })
end

loading()
