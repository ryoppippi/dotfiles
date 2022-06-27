local function loading()
  require("scrollbar.handlers.search").setup()
  require("scrollbar").setup({
    handlers = {
      diagnostic = true,
      search = true,
    },
    handle = {
      color = "#63768A",
    },
  })
end

require("utils.plugin").force_load_on_event("nvim-scrollbar", loading)
