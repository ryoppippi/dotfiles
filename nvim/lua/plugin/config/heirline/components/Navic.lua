return {
  provider = function()
    local location = require("nvim-navic").get_location()
    return #location > 0 and " > " .. location
  end,
  condition = function()
    local is_navic_enabled = vim.b.navic_client_id ~= nil
    local filename = vim.api.nvim_buf_get_name(0)
    local is_file_available = not tb(vim.fn.empty(vim.fn.fnamemodify(filename, "%:t")))
    return is_file_available and is_navic_enabled
  end,
}
