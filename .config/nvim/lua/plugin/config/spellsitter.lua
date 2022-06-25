local function loading()
  require("spellsitter").setup()
end
require("utils.plugin").force_load_on_event("spellsitter", loading)
