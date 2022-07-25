vim.g["fern#default_hidden"] = true
vim.g["fern#drawer_keep"] = true
vim.g["fern#renderer"] = "nerdfont"
-- vim.g["fern_auto_preview"] = true
-- vim.g["fern#keepjumps_on_edit"] = true
-- vim.g["fern#keepalt_on_edit"] = true

local my_glyph_palette = vim.api.nvim_create_augroup("my-glyph-palette", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "fern", "nerdtree", "startify" },
  group = my_glyph_palette,
  command = "call glyph_palette#apply()",
})

local fern_custon = vim.api.nvim_create_augroup("fern-custom", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "fern",
  group = fern_custon,
  callback = function()
    local opts = { buffer = true, silent = true, remap = true }
    vim.keymap.set("n", "p", "<Plug>(fern-action-preview:toggle)", opts)
    vim.keymap.set("n", "<C-p>", "<Plug>(fern-action-preview:auto:toggle)", opts)
    vim.keymap.set("n", "T", "<Plug>(fern-action-open:edit-or-tabedit)", opts)
    vim.keymap.set("n", "t", "<Nop>", opts)
    vim.keymap.set("n", "<C-d>", "<Plug>(fern-action-preview:scroll:down:half)", opts)
    vim.keymap.set("n", "<C-f>", "<Plug>(fern-action-preview:scroll:up:half)", opts)
    -- vim.keymap.set("n", "q", "<Plug>(fern-quit-or-close-preview)", opts)
    vim.cmd(
      [[nmap <silent> <buffer> <expr> <Plug>(fern-quit-or-close-preview) fern_preview#smart_preview("\<Plug>(fern-action-preview:close)", ":q\<CR>]]
    )
  end,
})

local fern_bufnr = nil
local function popup_fern()
  local function open_fern()
    vim.cmd([[Fern . -reveal=%]])
  end

  open_fern()
  -- if not fern_bufnr then
  --   open_fern()
  --   fern_bufnr = vim.api.nvim_get_current_buf()
  --   vim.cmd([[Back]])
  -- end
  -- local Popup = require("utils.plugin").force_require("nui.popup")
  -- if not Popup then
  --   return
  -- end
  -- local popup = Popup({
  --   enter = true,
  --   focusable = true,
  --   border = {
  --     style = "rounded",
  --   },
  --   relative = "editor",
  --   position = "50%",
  --   size = {
  --     width = "80%",
  --     height = "80%",
  --   },
  --   bufnr = fern_bufnr,
  --   buf_options = {},
  -- })
  -- popup:mount()
  -- popup:on("BufLeave", function()
  --   popup:unmount()
  -- end)
  -- popup:map("n", "<esc>", function()
  --   popup:unmount()
  -- end, { noremap = true })
end

vim.keymap.set("n", "<leader>e", popup_fern, { remap = true, silent = true })
vim.keymap.set("n", "<leader>E", "<cmd>Fern . -reveal=% -drawer -toggle -width=40<cr>", { remap = true })
