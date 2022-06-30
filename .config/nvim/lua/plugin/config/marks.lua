require("marks").setup({
  default_mappings = true, -- whether to map keybinds or not. default true
  builtin_marks = {},
  cyclic = true, -- whether movements cycle back to the beginning/end of buffer. default true
  force_write_shada = true, -- whether the shada file is updated after modifying uppercase marks. default false
  bookmark_0 = { -- marks.nvim allows you to configure up to 10 bookmark groups, each with its own sign/virttext
    sign = "⚑",
  },
})
