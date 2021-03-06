local function setup(pluin_name, options)
  local status, req = pcall(require, pluin_name)
  if status then
    req.setup(options)
  end
end

setup("mini.indentscope", {})
-- setup('mini.cursorword',{})
setup("mini.jump", {
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
-- setup("mini.jump2d", { mappings = { start_jumping = "<cr>" } })
setup("mini.trailspace", {})
