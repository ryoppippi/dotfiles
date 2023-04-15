return setmetatable({ provider = " " }, {
  __call = function(_, n)
    return { provider = string.rep(" ", n) }
  end,
})
