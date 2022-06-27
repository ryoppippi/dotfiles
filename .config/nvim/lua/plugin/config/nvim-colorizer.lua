local function loading()
  require("colorizer").setup()
end

require("utils.plugin").force_load_on_event("nvim-colorizer", loading)
