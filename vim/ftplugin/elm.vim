" Automatic line wraps.
setlocal textwidth=100

" Set a line at column where text will wrap.
setlocal colorcolumn=101

" Toggle things on window leave/enter to make which window is active more
" obvious.
augroup FtBgHighlight
  autocmd!
  autocmd WinEnter * set colorcolumn=101
  autocmd WinLeave * set colorcolumn=0
augroup END

" Ale configuration values.
let g:ale_elm_format_executable = 'elm-format'
let g:ale_elm_lsp_executable = 'elm-lsp'
let g:ale_elm_make_executable = 'elm'

" Ale linters and fixer.
let b:ale_linters = ['elm-format']
let b:ale_fixers = ['elm-format']
