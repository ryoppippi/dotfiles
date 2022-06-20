local plugin_name = "hlargs"

local function loading()
  require("hlargs").setup()
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = loading,
})
