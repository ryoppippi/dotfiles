local conditions = require("heirline.conditions")

return {
  init = function(self)
    self.filename = vim.api.nvim_buf_get_name(0)
  end,
  hl = function()
    local opt = { bold = true }
    if vim.bo.modified then
      -- use `force` because we need to override the child's hl foreground
      opt.fg = "cyan"
      opt.force = true
    end
    return opt
  end,
  provider = function(self)
    local filename = vim.fn.fnamemodify(self.filename, ":.")
    if filename == "" then
      filename = "[No Name]"
    end
    if not conditions.width_percent_below(#filename, 0.25) then
      filename = vim.fn.pathshorten(filename)
    end
    return filename
  end,
}
