local plugin_name = "lspsaga"
if not require("utils.plugin").is_exists(plugin_name) then
  return
end

local opt = { silent = true, nowait = true, buffer = 0 }
local loading = function()
  require(plugin_name).setup({
    use_saga_diagnostic_sign = true,
    error_sign = " ",
    warn_sign = " ",
    infor_sign = " ",
    hint_sign = "",
    border_style = "round",
  })

  local lspsaga_filetypes = vim.api.nvim_create_augroup("lspsaga_filetypes", { clear = true })
  vim.api.nvim_create_autocmd("Filetype", {
    pattern = "LspsagaHover",
    callback = function()
      vim.keymap.set("n", [[<ESC>]], [[<cmd>q<cr>]], opt)
    end,
    group = lspsaga_filetypes,
  })
  vim.api.nvim_create_autocmd("Filetype", {
    pattern = "LspsagaHover",
    callback = function()
      for _, key in ipairs({ "h", "j", "k", "l" }) do
        vim.keymap.set("n", key, [[<cmd>q<cr>]] .. key, opt)
      end
      vim.keymap.set("n", "<C-d>", function()
        require("lspsaga.action").smart_scroll_with_saga(1)
      end, opt)
      vim.keymap.set("n", "<C-f>", function()
        require("lspsaga.action").smart_scroll_with_saga(-1)
      end, opt)
    end,
    group = lspsaga_filetypes,
  })
end

local function keymap()
  vim.keymap.set("n", "gh", [[<cmd>Lspsaga hover_doc<cr>]], opt)
  -- vim.keymap.set('n', 'gj', [[<cmd>Lspsaga preview_definition<cr>]], opt)
  vim.keymap.set("n", "gk", [[<cmd>Lspsaga signature_help<cr>]], opt)
  vim.keymap.set("n", "gK", [[<cmd>Lspsaga lsp_finder<cr>]], opt)

  vim.keymap.set("n", "gj", [[<cmd>Lspsaga show_line_diagnostics<cr>]], opt)
  vim.keymap.set("n", "-", [[<cmd>Lspsaga diagnostic_jump_next<cr>]], opt)
  vim.keymap.set("n", "_", [[<cmd>Lspsaga diagnostic_jump_prev<cr>]], opt)

  vim.keymap.set("n", "cW", [[<cmd>Lspsaga rename<cr>]], opt)

  vim.keymap.set("n", "<leader>ag", [[<cmd>Lspsaga open_floaterm lazygit<cr>]], opt)
  vim.keymap.set("n", "<leader>aa", [[<cmd>Lspsaga open_floaterm<cr>]], opt)
  vim.keymap.set("n", "<leader>ac", [[<cmd>Lspsaga close_floaterm<cr>]], opt)
  vim.keymap.set("t", "<ESC>", [[<cmd>Lspsaga close_floaterm<cr>]], opt)
end

local function callback()
  loading()
  keymap()
end

require("utils.plugin").force_load_on_event(plugin_name, callback)
