" Ale configuration values.
let g:ale_elm_format_executable = 'elm-format'
let g:ale_elm_lsp_executable = 'elm-lsp'
let g:ale_elm_make_executable = 'elm'

" Ale linters and fixer.
let b:ale_linters = ['elm-format']
let b:ale_fixers = ['elm-format']
