require("noice").setup({
  popupmenu = {
    enabled = false,
  },
  notify = {
    enabled = false,
  },
  routes = {
    {
      filter = { event = "msg_show", kind = "search_count" },
      opts = { skip = true },
    },
  },
})
