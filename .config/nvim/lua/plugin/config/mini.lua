return {
  "echasnovski/mini.nvim",
  branch = "stable",
  -- lazy = false,
  event = "VeryLazy",
  config = function()
    require("mini.indentscope").setup({})

    require("mini.jump").setup({
      mappings = {
        forward = "f",
        backward = "F",
        forward_till = "",
        backward_till = "",
        repeat_jump = "",
      },
      delay = {
        highlight = 10,
      },
    })

    require("mini.trailspace").setup({})
    vim.api.nvim_create_user_command("TrimSpace", MiniTrailspace.trim, {})
    -- setup('mini.cursorword',{})

    -- setup("mini.jump2d", { mappings = { start_jumping = "<cr>" } })
  end,
}
