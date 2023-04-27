return {
  "RubixDev/mason-update-all",
  dependencies = {
    "williamboman/mason.nvim",
  },
  config = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "LazyUpdate",
      callback = function()
        require("mason-update-all").update_all()
      end,
      desc = "Run mason-update-all after packer.sync()",
    })
  end,
}
