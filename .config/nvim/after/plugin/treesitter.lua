local status, ts = pcall(require,"nvim-treesitter.configs")
if (not status) then return end


require'nvim-treesitter.configs'.setup {
  -- One of "all", "maintained" (parsers with maintainers), or a list of languages
  ensure_installed = "maintained",

  -- Install languages synchronously (only applied to `ensure_installed`)
  sync_install = false,


  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  context_commentstring = {
    enable = true
  },

  rainbow = {
    enable = true,
    extended_mode = true,
  },
}
