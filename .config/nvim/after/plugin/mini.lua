function load()
  -- local statusC, cursorword = pcall(require, "mini.cursorword")
  -- if not statusC then
  --   return
  -- end
  -- cursorword.setup()

  local status, indent = pcall(require, "mini.indentscope")
  if status then
    indent.setup()
  end

  local statusJ, jump = pcall(require, "mini.jump")
  if statusJ then
    jump.setup({
      mappings = {
        forward = "f",
        backward = "F",
        -- forward_till = "t",
        forward_till = "",
        -- backward_till = "T",
        backward_till = "",
        repeat_jump = "",
      },

      -- Delay (in ms) between jump and highlighting all possible jumps. Set to
      -- a very big number (like 10^7) to virtually disable highlighting.
      highlight_delay = 100,
    })
  end
end

vim.api.nvim_create_autocmd("VimEnter", {
  callback = load,
})
