if !exists('g:loaded_lexima')
      finish
endif
"
let g:lexima_enable_endwise_rules = 1
let g:lexima_enable_newline_rules = 1

" call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': 'html'})

let s:rules = []  
"" Don't add pairs if the next char is alphanumeric

"" Parenthesis
let s:rules += [
                  \ { 'char': '<C-h>', 'at': '(\%#)', 'input': '<BS><Del>', },
                  \ { 'char': '<BS>',  'at': '(\%#)', 'input': '<BS><Del>', },
                  \ ]

"" Brace
let s:rules += [
                  \ { 'char': '<C-h>', 'at': '{\%#}', 'input': '<BS><Del>', },
                  \ { 'char': '<BS>',  'at': '{\%#}', 'input': '<BS><Del>', },
                  \ ]

"" Bracket
let s:rules += [
                  \ { 'char': '<C-h>', 'at': '\[\%#\]', 'input': '<BS><Del>', },
                  \ { 'char': '<BS>',  'at': '\[\%#\]', 'input': '<BS><Del>', },
                  \ ]

"" Single Quote
let s:rules += [
                  \ { 'char': '<C-h>', 'at': "'\\%#'", 'input': '<BS><Del>', },
                  \ { 'char': '<BS>',  'at': "'\\%#'", 'input': '<BS><Del>', },
                  \ ]

"" Double Quote
let s:rules += [
                  \ { 'char': '<C-h>', 'at': '"\%#"', 'input': '<BS><Del>', },
                  \ { 'char': '<BS>',  'at': '"\%#"', 'input': '<BS><Del>', },
                  \ ]

"" Back Quote
let s:rules += [
                  \ { 'char': '<C-h>', 'at': '`\%#`', 'input': '<BS><Del>', },
                  \ { 'char': '<BS>',  'at': '`\%#`', 'input': '<BS><Del>', },
                  \ ]

"" Move closing parenthesis
let s:rules += [
                  \ { 'char': '<C-f>', 'at': '\%#\s*)',  'leave': ')',  },
                  \ { 'char': '<C-f>', 'at': '\%#\s*\}', 'leave': '}',  },
                  \ { 'char': '<C-f>', 'at': '\%#\s*\]', 'leave': ']',  },
                  \ { 'char': '<C-f>', 'at': '\%#\s*''', 'leave': '''', },
                  \ { 'char': '<C-f>', 'at': '\%#\s*"',  'leave': '"',  },
                  \ { 'char': '<C-f>', 'at': '\%#\s*`',  'leave': '`',  },
                  \ ]

"" Insert semicolon at the end of the line
let s:rules += [
                  \ { 'char': ';', 'at': '(.*;\%#)$',   'input': '<BS><Right>;' },
                  \ { 'char': ';', 'at': '^\s*;\%#)$',  'input': '<BS><Right>;' },
                  \ { 'char': ';', 'at': '(.*;\%#\}$',  'input': '<BS><Right>;' },
                  \ { 'char': ';', 'at': '^\s*;\%#\}$', 'input': '<BS><Right>;' },
                  \ ]

"" Surround function
let s:rules += [
                  \ { 'char': '>', 'at': ')\%#', 'input': '<BS><C-o>normal! f(%a)<Esc>' },
                  \ ]

"" TypeScript
let s:rules += [
                  \ { 'filetype': ['typescript', 'typescriptreact', 'javascript', 'svelte'], 'char': '>', 'at': '\s([a-zA-Z, ]*>\%#)',             'delete': ')', 'input': '<BS>) => {', 'input_after': '}' },
                  \ { 'filetype': ['typescript', 'typescriptreact', 'javascript', 'svelte'], 'char': '>', 'at': '[a-zA-Z<>]\+(([a-zA-Z, ]*>\%#))', 'delete': ')', 'input': '<BS>) => {', 'input_after': '}' },
                  \ ]

" TSX with nvim-ts-autotag
" if dein#tap('nvim-ts-autotag')
      let s:rules += [
                        \ { 'filetype': ['typescriptreact'], 'char': '>', 'at': '<[a-zA-Z.]\+\(\s\)\?.*\%#', 'input': '><Esc>:lua require(''nvim-ts-autotag.internal'').close_tag()<CR>a', },
                        \ ]
" endif

"" ruby
let s:rules += [
                  \ { 'filetype': 'ruby', 'char': '<CR>',  'at': '^\s*\%(module\|def\|class\|if\|unless\)\s\w\+\((.*)\)\?\%#$', 'input': '<CR>',         'input_after': 'end',          },
                        \ { 'filetype': 'ruby', 'char': '<CR>',  'at': '^\s*\%(begin\)\s*\%#',                                        'input': '<CR>',         'input_after': 'end',          },
                        \ { 'filetype': 'ruby', 'char': '<CR>',  'at': '\%(^\s*#.*\)\@<!do\%(\s*|.*|\)\?\s*\%#',                      'input': '<CR>',         'input_after': 'end',          },
                        \ { 'filetype': 'ruby', 'char': '<Bar>', 'at': 'do\%#',                                                       'input': '<Space><Bar>', 'input_after': '<Bar><CR>end', },
                        \ { 'filetype': 'ruby', 'char': '<Bar>', 'at': 'do\s\%#',                                                     'input': '<Bar>',        'input_after': '<Bar><CR>end', },
                        \ { 'filetype': 'ruby', 'char': '<Bar>', 'at': '{\%#}',                                                       'input': '<Space><Bar>', 'input_after': '<Bar><Space>', },
                        \ { 'filetype': 'ruby', 'char': '<Bar>', 'at': '{\s\%#\s}',                                                   'input': '<Bar>',        'input_after': '<Bar><Space>', },
                        \ ]

"" eruby
let s:rules += [
                  \ { 'filetype': 'eruby', 'char': '%',     'at': '<\%#',         'input': '%<Space>',                        'input_after': '<Space>%>',                 },
                  \ { 'filetype': 'eruby', 'char': '=',     'at': '<%\%#',        'input': '=<Space><Right>',                 'input_after': '<Space>%>',                 },
                  \ { 'filetype': 'eruby', 'char': '=',     'at': '<%\s\%#\s%>',  'input': '<Left>=<Right>',                                                              },
                  \ { 'filetype': 'eruby', 'char': '=',     'at': '<%\%#.\+%>',                                                                           'priority': 10, },
                  \ { 'filetype': 'eruby', 'char': '<C-h>', 'at': '<%\s\%#\s%>',  'input': '<BS><BS><BS><Del><Del><Del>',                                                 },
                  \ { 'filetype': 'eruby', 'char': '<BS>',  'at': '<%\s\%#\s%>',  'input': '<BS><BS><BS><Del><Del><Del>',                                                 },
                  \ { 'filetype': 'eruby', 'char': '<C-h>', 'at': '<%=\s\%#\s%>', 'input': '<BS><BS><BS><BS><Del><Del><Del>',                                             },
                  \ { 'filetype': 'eruby', 'char': '<BS>',  'at': '<%=\s\%#\s%>', 'input': '<BS><BS><BS><BS><Del><Del><Del>',                                             },
                  \ ]

"" markdown
let s:rules += [
                  \ { 'filetype': 'markdown', 'char': '#',       'at': '^\%#\%(#\)\@!',                  'input': '#<Space>'                           },
                  \ { 'filetype': 'markdown', 'char': '#',       'at': '#\s\%#',                         'input': '<BS>#<Space>',                      },
                  \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
                  \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
                  \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^#\s\%#',                        'input': '<BS><BS>'                           },
                  \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '##\s\%#',                        'input': '<BS><BS><Space>',                   },
                  \ { 'filetype': 'markdown', 'char': '-',       'at': '^\s*\%#',                        'input': '-<Space>',                          },
                  \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\%#',                     'input': '<Home><Tab><End>',                  },
                  \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\w.*\%#',                 'input': '<Home><Tab><End>',                  },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\%#',                    'input': '<Home><Del><Del><End>',             },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\w.*\%#',                'input': '<Home><Del><Del><End>',             },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\w.*\%#',                    'input': '',                                  },
                  \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
                  \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
                  \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\%#',                        'input': '<C-w><BS>',                         },
                  \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><BS>',                    },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\%#',                        'input': '<C-w><CR>',                         },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\%#',                    'input': '<C-w><C-w><CR>',                    },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\w.*\%#',                 'input': '<CR>-<Space>',                      },
                  \ { 'filetype': 'markdown', 'char': '[',       'at': '^\s*-\s\%#',                     'input': '<Left><Space>[]<Left>',             },
                  \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\%#\]\s',               'input': '<Home><Tab><End><Left><Left>',      },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\[\%#\]\s',                  'input': '',                                  },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\%#\]\s',              'input': '<Home><Del><Del><End><Left><Left>', },
                  \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
                  \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s*-\s\[\%#\]',                 'input': '<BS><Del><Del>',                    },
                  \ { 'filetype': 'markdown', 'char': '<Space>', 'at': '^\s*-\s\[\%#\]',                 'input': '<Space><End>',                      },
                  \ { 'filetype': 'markdown', 'char': 'x',       'at': '^\s*-\s\[\%#\]',                 'input': 'x<End>',                            },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\%#\]',                    'input': '<End><C-w><C-w><C-w><CR>',          },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\%#\]',                'input': '<End><C-w><C-w><C-w><C-w><CR>',     },
                  \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\%#',      'input': '<Home><Tab><End>',                  },
                  \ { 'filetype': 'markdown', 'char': '<Tab>',   'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<Home><Tab><End>',                  },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<Home><Del><Del><End>',             },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^\s\+-\s\[\(\s\|x\)\]\s\w.*\%#', 'input': '<Home><Del><Del><End>',             },
                  \ { 'filetype': 'markdown', 'char': '<S-Tab>', 'at': '^-\s\[\(\s\|x\)\]\s\w.*\%#',     'input': '',                                  },
                  \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
                  \ { 'filetype': 'markdown', 'char': '<C-h>',   'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
                  \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><BS>',               },
                  \ { 'filetype': 'markdown', 'char': '<BS>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><BS>',          },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^-\s\[\(\s\|x\)\]\s\%#',         'input': '<C-w><C-w><C-w><CR>',               },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s\+-\s\[\(\s\|x\)\]\s\%#',     'input': '<C-w><C-w><C-w><C-w><CR>',          },
                  \ { 'filetype': 'markdown', 'char': '<CR>',    'at': '^\s*-\s\[\(\s\|x\)\]\s\w.*\%#',  'input': '<CR>-<Space>[]<Space><Left><Left>', },
                  \ ]

for s:rule in s:rules
      call lexima#add_rule(s:rule)
endfor


